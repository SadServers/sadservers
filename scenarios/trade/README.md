# "Trade": FIX drop reconciliation

## Description

FIX (Financial Information eXchange) is a common electronic protocol for trading. Messages are <kbd>tag=value</kbd> fields separated by SOH (ASCII <kbd>0x01</kbd>; logs here use <kbd>|</kbd>). A message starts with <kbd>8=</kbd> (BeginString), <kbd>9=</kbd> (BodyLength), <kbd>35=</kbd> (MsgType) and ends with <kbd>10=</kbd> (CheckSum). See <a href="https://fix.dev/kb/tag-value-encoding">FIX TagValue encoding</a>.
<br><br>
Our order router sends FIX orders to the exchange gateway and gets fills back. Yesterday the session dropped for a few minutes: the gateway kept executing, the router kept sending, but some fills never made it back.
<br><br>
Both sides log raw FIX 4.2 under <kbd>/home/admin/fix/</kbd>: <kbd>router.log</kbd> (what the router saw) and <kbd>gateway.log</kbd> (authoritative). Useful tags:
<pre>35  MsgType: D = NewOrderSingle (order), 8 = ExecutionReport (fill),
             5 = Logout, A = Logon, 4 = SequenceReset (session markers)
11  ClOrdID: client order ID on orders
17  ExecID: fill ID, unique per fill (e.g. EX000431)</pre>
Reconcile the two logs, find every fill the gateway executed but the router missed, and recover them by appending each missing <kbd>17=ExecID</kbd> (one per line) to <kbd>/home/admin/fix/fills.dat</kbd>, which already holds the fills the router saw. Do not add duplicates or fills the router already has.
<br><br>
Credit: <a href="https://alexpotato.com/">Alex Elliot</a>

## Test

<kbd>fills.dat</kbd> holds exactly the gateway's fill set: every <kbd>17=ExecID</kbd> from <kbd>gateway.log</kbd> is present once, with no extras or duplicates.<br><br>The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)
D=/home/admin/fix
G="$D/gateway.log"
F="$D/fills.dat"
T=$(mktemp -d) || { echo -n "NO"; exit 0; }
trap 'rm -rf "$T"' EXIT
[ -f "$G" ] || { echo -n "NO"; exit 0; }
[ -f "$F" ] || { echo -n "NO"; exit 0; }
grep -o '17=EX[0-9]*' "$G" | cut -d= -f2 | sort -u > "$T/exp" 2>/dev/null || { echo -n "NO"; exit 0; }
[ -s "$T/exp" ] || { echo -n "NO"; exit 0; }
awk '{sub(/\r$/,"");sub(/^[ \t]+/,"");sub(/[ \t]+$/,"");if($0=="")next;if(match($0,/17=EX[0-9]+/)){print substr($0,RSTART+3,RLENGTH-3)}else if($0~/^EX[0-9]+$/){print}else{exit 1}}' "$F" > "$T/got_raw" 2>/dev/null || { echo -n "NO"; exit 0; }
[ -s "$T/got_raw" ] || { echo -n "NO"; exit 0; }
if [ "$(wc -l < "$T/got_raw")" != "$(sort -u "$T/got_raw" | wc -l)" ]; then echo -n "NO"; exit 0; fi
grep -qv '^EX[0-9]\{6\}$' "$T/got_raw" && { echo -n "NO"; exit 0; }
sort -u "$T/got_raw" > "$T/got"
if cmp -s "$T/exp" "$T/got"; then echo -n "OK"; else echo -n "NO"; fi
exit 0
```
