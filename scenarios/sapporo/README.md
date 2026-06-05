# "Sapporo": ephemeral tokens

## Description

The Sapporo gate API on this host should answer on <kbd>http://127.0.0.1:9180/</kbd> with a body containing <kbd>OK</kbd>.
<br><br>
A background service writes short-lived tokens to <i>/var/lib/sapporo/pulse</i> (each value is visible for only a fraction of a second, then the file is cleared again). The gate compares <i>/home/admin/sapporo/active-token</i> against the latest emitted token.
<br><br>
The installed collector at <i>/home/admin/sapporo-collector.sh</i> (triggered by <i>sapporo-collector.timer</i> once per minute) never keeps up; <i>active-token</i> stays empty or stale and the gate keeps failing.
<br><br>
Fix collection so the current token is captured reliably and the gate returns <kbd>OK</kbd>.

## Test

<kbd>curl http://127.0.0.1:9180/</kbd> returns a response whose body contains <kbd>OK</kbd>, and <i>/home/admin/sapporo/active-token</i> holds a token matching the current pulse (format <kbd>SAPPORO-</kbd> followed by eight hex digits).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

GATE_URL="http://127.0.0.1:9180/"
ACTIVE="/home/admin/sapporo/active-token"

if ! curl -sf --max-time 1 "$GATE_URL" 2>/dev/null | grep -q 'OK'; then
  echo -n "NO"
  exit 0
fi

if [ ! -f "$ACTIVE" ]; then
  echo -n "NO"
  exit 0
fi

token=$(tr -d '\n' <"$ACTIVE")
if [[ ! "$token" =~ ^SAPPORO-[0-9A-F]{8}$ ]]; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
