# "Stockholm": DNS health check issue

## Description

The internal status portal on this host should answer on <kbd>http://127.0.0.1:9167/</kbd> with a body containing <kbd>OK</kbd>.
<br><br>
It worked until operations ran a package cleanup.
<br><br>
The portal service (<i>stockholm-portal</i>) only runs after a DNS health check at <i>/usr/local/bin/stockholm-dns-check.sh</i> succeeds.
<br><br>
Make the necessary changes so the portal works again.
<br><br>
Do not modify <i>/usr/local/bin/stockholm-dns-check.sh</i>.

## Test

The health script <i>/usr/local/bin/stockholm-dns-check.sh</i> runs successfully, <i>stockholm-portal</i> is <b>active</b>, and <kbd>curl http://127.0.0.1:9167/</kbd> returns a response whose body contains <kbd>OK</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

health_script_md5="$(md5sum /usr/local/bin/stockholm-dns-check.sh 2>/dev/null | awk '{print $1}')"
if [ "$health_script_md5" != "b86023aa075740ee332d14b19efe643f" ]; then
  echo -n "NO"
  exit 0
fi

if ! /usr/local/bin/stockholm-dns-check.sh >/dev/null 2>&1; then
  echo -n "NO"
  exit 0
fi

if ! systemctl is-active --quiet stockholm-portal.service; then
  echo -n "NO"
  exit 0
fi

if ! python3 -c "
import urllib.request
r = urllib.request.urlopen('http://127.0.0.1:9167/', timeout=2)
body = r.read().decode()
raise SystemExit(0 if 'OK' in body else 1)
" 2>/dev/null; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
