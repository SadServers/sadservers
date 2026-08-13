# "Banha" : Intermittent 504 Gateway Time-Out errors

## Description

Our Python Flask web application, served via Gunicorn and Nginx, is experiencing intermittent 504 Gateway Time-Out errors on concurrent requests. Users report that the application works perfectly at times, but fails unexpectedly at others. Your task is to identify the root cause of these sporadic failures and implement a permanent fix to ensure the applications consistent stability on port 80.

## Test

<kbd>curl http://localhost/</kbd> returns "Hello from Flask!" consistently, even on parallel load: <kbd>seq 15 | xargs -n1 -P15 curl -sf --max-time 5 http://localhost/ && echo OK || echo FAIL</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# The app must stay healthy under concurrent load (not only single requests).
PARALLEL=15
MARKER=$(mktemp -u)

for _ in $(seq 1 $PARALLEL); do
    (
        curl -sf --max-time 5 http://localhost/ | grep -q 'Hello from Flask!' || : >"$MARKER"
    ) &
done
wait

if [ -e "$MARKER" ]; then
    rm -f "$MARKER"
    echo -n "NO"
    exit 0
fi

echo -n "OK"
exit 0
```
