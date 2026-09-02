# "Hangzhou": The web server one-second delay that never happens

## Description

West Lake Quotes is a staging market-data gateway. <kbd>GET /v1/quote</kbd> on port <kbd>:80</kbd> should wait about <b>one second</b> and then return the matching engine payload. The engine itself listens on <kbd>127.0.0.1:5000</kbd> and must stay fast.
<br><br>
After last Thursday's nginx change the JSON is still correct, but the courtesy delay never happens — quotes come back in a few milliseconds. The mobile QA build depends on that wait (spinner and retry logic).
<br><br>
There is a short handover note in <i>/home/admin/HANDOVER.txt</i>. Do not take the gateway off port 80, and do not add latency to the engine.

## Test

<kbd>curl -s http://127.0.0.1/v1/quote</kbd> returns the engine JSON (fields <i>westlake</i> and <i>WLTEA</i>) and the request takes roughly one second.
<br><br>
<kbd>curl -s http://127.0.0.1:5000/v1/quote</kbd> still returns the same payload immediately.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() { echo -n "NO"; exit 0; }

engine_body=$(mktemp)
gw_hdr=$(mktemp)
gw_body=$(mktemp)
trap 'rm -f "$engine_body" "$gw_hdr" "$gw_body"' EXIT

engine_t=$(curl -sS -o "$engine_body" -w '%{time_total}' --max-time 1 \
    http://127.0.0.1:5000/v1/quote 2>/dev/null) || fail

grep -q 'westlake' "$engine_body" || fail
grep -q 'WLTEA' "$engine_body" || fail
awk -v t="$engine_t" 'BEGIN { exit (t+0 < 0.35) ? 0 : 1 }' || fail

gw_t=$(curl -sS -D "$gw_hdr" -o "$gw_body" -w '%{time_total}' --max-time 1.8 \
    http://127.0.0.1/v1/quote 2>/dev/null) || fail

grep -q 'westlake' "$gw_body" || fail
grep -q 'WLTEA' "$gw_body" || fail
grep -qiE '^Server:[[:space:]]*(nginx|openresty)' "$gw_hdr" || fail
awk -v t="$gw_t" 'BEGIN { exit (t+0 >= 0.8) ? 0 : 1 }' || fail

echo -n "OK"
exit 0
```
