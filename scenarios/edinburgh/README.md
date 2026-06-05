# "Edinburgh": FTP catalog sync failure

## Description

The warehouse API on this host should answer on <kbd>http://127.0.0.1:9178/</kbd> with a body containing <kbd>OK</kbd>.
<br><br>
It depends on a catalog file pulled from the internal FTP mirror at <kbd>127.0.0.1</kbd>.
<br><br>
The sync job at <i>/home/admin/edinburgh-sync.sh</i> is failing; <i>edinburgh-sync</i> is in a <b>failed</b> state and the API never comes up healthy.
<br><br>
Fix the sync so the catalog is downloaded and the API works again.

## Test

<i>/var/lib/edinburgh/catalog.txt</i> exists with the correct inventory data, the service <i>edinburgh-api</i> is <b>active</b>, and <kbd>curl http://127.0.0.1:9178/</kbd> returns a response whose body contains <kbd>OK</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

CATALOG="/var/lib/edinburgh/catalog.txt"
EXPECTED_MD5="fcc2224a84f8192dcaed3b15ef6e8cce"

if [ ! -f "$CATALOG" ]; then
  echo -n "NO"
  exit 0
fi

actual_md5="$(md5sum "$CATALOG" | awk '{print $1}')"
if [ "$actual_md5" != "$EXPECTED_MD5" ]; then
  echo -n "NO"
  exit 0
fi

if ! systemctl is-active --quiet edinburgh-api.service; then
  echo -n "NO"
  exit 0
fi

if ! python3 -c "
import urllib.request
r = urllib.request.urlopen('http://127.0.0.1:9178/', timeout=2)
body = r.read().decode()
raise SystemExit(0 if 'OK' in body else 1)
" 2>/dev/null; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
