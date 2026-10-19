# "Flip": algo symbol flips

## Description

FIX (Financial Information eXchange) is an electronic protocol for trading. Messages are <kbd>tag=value</kbd> fields separated by SOH (ASCII <kbd>0x01</kbd>; logs here use <kbd>|</kbd>). A message starts with <kbd>8=</kbd> (BeginString), <kbd>9=</kbd> (BodyLength), <kbd>35=</kbd> (MsgType) and ends with <kbd>10=</kbd> (CheckSum). See <a href="https://fix.dev/kb/tag-value-encoding">FIX encoding</a>.
<br><br>
Our execution algo has a bug: on some fills it stamps the wrong symbol, e.g. an <kbd>AAPL</kbd> execution labeled <kbd>DELL</kbd>, <kbd>GOOG</kbd> labeled <kbd>INTC</kbd>.<br><br>
You get three files: reference market data at <kbd>/home/admin/market/BANDS.csv</kbd> (<kbd>symbol,min_px,max_px</kbd> bands that never overlap), plus <kbd>/home/admin/fix/orders.log</kbd> (<kbd>35=D</kbd> orders with <kbd>11=ClOrdID</kbd> and true <kbd>55=Symbol</kbd>) and <kbd>/home/admin/fix/executions.log</kbd> (<kbd>35=8</kbd> fills with <kbd>17=ExecID</kbd>, <kbd>11=ClOrdID</kbd>, stamped <kbd>55=Symbol</kbd>, <kbd>31=LastPx</kbd>).<br><br>
FIX tag dictionary (lines look like <kbd>8=FIX.4.2|9=...|...|10=...|</kbd>, <kbd>|</kbd> in place of the SOH delimiter):
<pre>35  MsgType: D = NewOrderSingle (order), 8 = ExecutionReport (fill)
11  ClOrdID: client order ID (links a fill back to its order)
17  ExecID: fill ID, unique per fill (e.g. EX000123)
55  Symbol: true symbol on orders, as-stamped (possibly wrong) on fills
31  LastPx: price of this fill</pre>
There are two independent ways to catch a flip: show the execution price is impossible for the stamped symbol against the market data bands (e.g. a <kbd>$75</kbd> fill labeled <kbd>GOOG</kbd> whose band is <kbd>$20-$30</kbd>), or join <kbd>11=ClOrdID</kbd> back to the order's true <kbd>55=</kbd>. Create <kbd>/home/admin/fix/corrections.csv</kbd> with one <kbd>ExecID,correct_symbol</kbd> per line listing <b>only</b> the flipped fills with their true symbols.
<br><br>
Credit <a href="https://alexpotato.com/">Alex Elliot</a>

## Test

<kbd>corrections.csv</kbd> lists exactly the flipped fills (~25 of ~960): every <kbd>ExecID</kbd> paired with its true symbol, no missing, extras, or duplicates.<br><br>The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

D=/home/admin/fix
F="$D/corrections.csv"
T=$(mktemp -d) || { echo -n "NO"; exit 0; }
trap 'rm -rf "$T"' EXIT
[ -f "$F" ] || { echo -n "NO"; exit 0; }
EXP_HASH="c3d1e3fa97cee2bd0acf0e779fcd13a147c23441a7e2d15c3729e5cc726d4fb9"
EXP_COUNT=25
awk 'BEGIN{FS="[,; \t]+"} {sub(/\r$/,"");sub(/^[ \t]+/,"");sub(/[ \t]+$/,"");if($0=="")next;if(NR==1&&$0~/^[Ee][Xx][Ee][Cc]/)next;e="";s="";U=toupper($0);if(match(U,/17=EX[0-9]+/)){e=substr(U,RSTART+3,RLENGTH-3);s=$2}else{e=toupper($1);s=$2}if(e=="")exit 1;if(match(e,/EX[0-9]+/)){e=substr(e,RSTART,RLENGTH)}else exit 1;if(s=="")exit 1;s=toupper(s);gsub(/[^A-Z]/,"",s);if(e!~/^EX[0-9]+$/)exit 1;if(s!~/^(GOOG|INTC|DELL|AAPL|MSFT|NVDA)$/)exit 1;print e","s}' "$F" > "$T/raw" 2>/dev/null || { echo -n "NO"; exit 0; }
[ -s "$T/raw" ] || { echo -n "NO"; exit 0; }
if [ "$(wc -l < "$T/raw")" != "$(sort -u "$T/raw" | wc -l)" ]; then echo -n "NO"; exit 0; fi
sort -u "$T/raw" > "$T/got"
[ "$(wc -l < "$T/got")" = "$EXP_COUNT" ] || { echo -n "NO"; exit 0; }
if [ "$(sha256sum "$T/got" | cut -d" " -f1)" = "$EXP_HASH" ]; then echo -n "OK"; else echo -n "NO"; fi
exit 0
```
