# "Verona": Apache Portal Won't Open

## Description

An internal Apache portal was migrated to this host. The document root is <i>/var/www/portal</i>.
<br><br>
The site root at <kbd>http://localhost/</kbd> does not serve the expected homepage, and a legacy bookmark at <kbd>/reports</kbd> no longer reaches the status page (direct access to <kbd>/status/</kbd> works).
<br><br>
Find and fix what keeps the portal root and the legacy redirect from working. Adding missing content is allowed.

## Test

<kbd>curl http://localhost/</kbd> returns a first line of <kbd>SadServers - Portal Ready</kbd>.
<br><br>
<kbd>curl -L http://localhost/reports</kbd> returns a first line of <kbd>SadServers - Status OK</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() {
  echo -n "NO"
  exit 0
}

root=$(curl -s -m 2 http://127.0.0.1/ | head -n 1)
if [ "$root" != "SadServers - Portal Ready" ]; then
  fail
fi

status=$(curl -s -m 2 -L http://127.0.0.1/reports | head -n 1)
if [ "$status" != "SadServers - Status OK" ]; then
  fail
fi

echo -n "OK"
```
