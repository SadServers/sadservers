# "Bergen": Port already in use

## Description

There's an application at <i>/home/admin/standalone</i> that needs to run successfully but currently it fails.
<br><br>Fix the environment so the binary can run without errors, without changing the binary itself, and without breaking the web app served on port <kbd>:80</kbd>.

## Test

Running <kbd>/home/admin/standalone</kbd> prints <kbd>OK</kbd> and <kbd>curl http://localhost:80</kbd> returns <kbd>hello SadServers</kbd>.<br>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

EXPECTED_BIN_MD5="4d3bc8d9e2ae0e283f8ab4c46e3ae06b"

actual_md5=$(md5sum /home/admin/standalone 2>/dev/null | awk '{print $1}')
if [ "$actual_md5" != "$EXPECTED_BIN_MD5" ]; then
  echo -n "NO"
  exit 0
fi

out=$(/home/admin/standalone 2>&1)
if [ "$out" != "OK" ]; then
  echo -n "NO"
  exit 0
fi

if ! systemctl is-active --quiet nginx; then
  echo -n "NO"
  exit 0
fi

if ! systemctl is-active --quiet django; then
  echo -n "NO"
  exit 0
fi

resp=$(curl -s -m 1 http://127.0.0.1:80/ 2>/dev/null || true)
if [ "$resp" != "hello SadServers" ]; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
