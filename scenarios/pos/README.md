# "Pos": position manager down + reconcile

## Description

FIX (Financial Information eXchange) is a common electronic protocol for trading. Messages are <kbd>tag=value</kbd> fields separated by SOH (ASCII <kbd>0x01</kbd>; logs here use <kbd>|</kbd>). A message starts with <kbd>8=</kbd> (BeginString), <kbd>9=</kbd> (BodyLength), <kbd>35=</kbd> (MsgType) and ends with <kbd>10=</kbd> (CheckSum). See <a href="https://fix.dev/kb/tag-value-encoding">FIX TagValue encoding</a>.
<br><br>
Dev just called: a deployment of the position manager service (<kbd>posmgr</kbd>, a systemd service) went wrong in prod. They've asked you to take a look — <kbd>posmgr show</kbd> just errors. Get the service back to <kbd>active</kbd> first.<br><br>
Once it is up, query the service for its CURRENT view (<kbd>posmgr show</kbd>). That view is stale: the authoritative trade history is <kbd>/home/admin/fix/executions.log</kbd>, raw FIX 4.2 <kbd>35=8</kbd> fills carrying <kbd>55=Symbol</kbd>, <kbd>54=Side</kbd> (<kbd>1</kbd>=Buy, <kbd>2</kbd>=Sell) and <kbd>32=LastQty</kbd>.<br><br>
FIX tag dictionary (lines look like <kbd>8=FIX.4.2|9=...|35=8|...|10=...|</kbd>, <kbd>|</kbd> in place of the SOH delimiter):
<pre>35  MsgType: D = NewOrderSingle (order), 8 = ExecutionReport (fill)
11  ClOrdID: client order ID (links a fill back to its order)
17  ExecID: fill ID, unique per fill (e.g. EX000151)
55  Symbol: e.g. AAPL, MSFT, TSLA, NVDA, AMD
54  Side: 1 = Buy, 2 = Sell
32  LastQty: shares in this fill
31  LastPx: price of this fill</pre>
Reconcile the two and write the TRUE positions to <kbd>/home/admin/fix/positions.csv</kbd> as <kbd>SYMBOL,QTY</kbd> per line (net = buys minus sells). The file does not exist yet; you create it.
<br><br>
Credit <a href="https://alexpotato.com/">Alex Elliot</a>

## Test

<kbd>posmgr.service</kbd> is <kbd>active</kbd> and <kbd>positions.csv</kbd> holds exactly the nets from <kbd>executions.log</kbd>: every symbol with its true net qty, no missing, extras or dups.
<br><br>The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

D=/home/admin/fix
E="$D/executions.log"
F="$D/positions.csv"
T=$(mktemp -d) || { echo -n "NO"; exit 0; }
trap 'rm -rf "$T"' EXIT
if systemctl cat posmgr.service >/dev/null 2>&1; then
  systemctl is-active --quiet posmgr || { echo -n "NO"; exit 0; }
else
  pgrep -f "[p]osmgr daemon" >/dev/null || { echo -n "NO"; exit 0; }
fi
posmgr show >/dev/null 2>&1 || { echo -n "NO"; exit 0; }
[ -f "$E" ] || { echo -n "NO"; exit 0; }
[ -f "$F" ] || { echo -n "NO"; exit 0; }
awk -F'|' '{s="";d="";q="";for(i=1;i<=NF;i++){if($i~/^55=[A-Z]+$/){s=substr($i,4)}else if($i~/^54=[12]$/){d=substr($i,4)}else if($i~/^32=[0-9]+$/){q=substr($i,4)}}if(index($0,"35=8")&&s!=""&&d!=""&&q!=""){if(d==1){nets[s]+=q}else{nets[s]-=q}}}END{for(k in nets)print k","nets[k]}' "$E" | sort > "$T/exp" 2>/dev/null || { echo -n "NO"; exit 0; }
[ -s "$T/exp" ] || { echo -n "NO"; exit 0; }
awk 'BEGIN{FS="[,; \t]+"} {sub(/\r$/,"");sub(/^[ \t]+/,"");sub(/[ \t]+$/,"");if($0=="")next;if(NR==1&&toupper($0)~/^SYMBOL/)next;sym=toupper($1);gsub(/[^A-Z]/,"",sym);qty=$2;gsub(/[^0-9-]/,"",qty);if(sym=="")exit 1;if(qty==""||qty=="-"||qty !~ /^-?[0-9]+$/)exit 1;print sym","(qty+0)}' "$F" > "$T/got_raw" 2>/dev/null || { echo -n "NO"; exit 0; }
[ -s "$T/got_raw" ] || { echo -n "NO"; exit 0; }
if [ "$(wc -l < "$T/got_raw")" != "$(sort -u "$T/got_raw" | wc -l)" ]; then echo -n "NO"; exit 0; fi
sort -u "$T/got_raw" > "$T/got"
[ "$(wc -l < "$T/got")" = "$(wc -l < "$T/exp")" ] || { echo -n "NO"; exit 0; }
if cmp -s "$T/exp" "$T/got"; then echo -n "OK"; else echo -n "NO"; fi
exit 0
```
