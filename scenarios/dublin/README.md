# "Dublin": registration queue overload (HTTP 429)

## Description

Open enrollment is live and the student registration portal is rejecting traffic.<br><br>
The app runs on this VM (no containers): Redis-backed background jobs, systemd workers, manual deploy. During the spike the portal at localhost:5000 returns <kbd>HTTP 429</kbd> on <kbd>POST /register</kbd> e.g. <kbd>curl -i -X POST http://127.0.0.1:5000/register</kbd> (header and payload not needed to simplify).
<br><br>
Services live under systemd as <kbd>registration-app</kbd>, <kbd>registration-worker@N</kbd>, and <kbd>registration-loadgen</kbd> (the load generator <b>simulates ongoing external enrollment traffic</b> — treat it like real users arriving; do not "fix" the outage by turning that traffic off). Redis queue name: <kbd>registration:jobs</kbd>. Useful endpoints on port <kbd>5000</kbd>:
<pre>
GET  /          portal home
POST /register  enqueue a registration (429 when overloaded)
GET  /metrics   Redis queue lengths (queue_jobs, queue_failed, ...)
</pre>
Find why the backlog will not drain and restore capacity so registrations are accepted again <b>while traffic continues</b>. You do not need to change application Python under <kbd>/opt/registration/</kbd>.

## Test

<kbd>registration-loadgen</kbd> stays active, <kbd>curl -s http://127.0.0.1:5000/metrics</kbd> shows <kbd>queue_jobs</kbd> below <kbd>50</kbd>, and <kbd>curl -s -o /dev/null -w '%{http_code}\n' -X POST http://127.0.0.1:5000/register</kbd> returns <kbd>202</kbd> (not <kbd>429</kbd>) repeatedly.<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

APP_URL="${APP_URL:-http://127.0.0.1:5000}"
MAX_DEPTH=50
MIN_WORKERS=3
OK=1

if ! command -v redis-cli >/dev/null 2>&1; then
  echo -n "NO"
  exit 0
fi

# Simulated external traffic must still be running (do not "fix" by stopping it)
systemctl is-active --quiet registration-loadgen 2>/dev/null || OK=0

DEPTH=$(redis-cli LLEN registration:jobs 2>/dev/null | tr -d '\r')
case "$DEPTH" in
  ''|*[!0-9]*) OK=0 ;;
  *) [ "$DEPTH" -lt "$MAX_DEPTH" ] || OK=0 ;;
esac

METRICS=$(curl -sf --max-time 2 "$APP_URL/metrics" 2>/dev/null || true)
echo "$METRICS" | grep -qE '^queue_jobs [0-9]+$' || OK=0
MDEPTH=$(echo "$METRICS" | awk '/^queue_jobs / {print $2; exit}')
case "$MDEPTH" in
  ''|*[!0-9]*) OK=0 ;;
  *) [ "$MDEPTH" -lt "$MAX_DEPTH" ] || OK=0 ;;
esac

WORKERS=$(pgrep -fc '/opt/registration/worker.py' 2>/dev/null || echo 0)
case "$WORKERS" in
  ''|*[!0-9]*) WORKERS=0 ;;
esac
[ "$WORKERS" -ge "$MIN_WORKERS" ] || OK=0

CODE=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 \
  -X POST "$APP_URL/register" -H 'Content-Type: application/json' \
  -d '{"student":"check"}' 2>/dev/null || echo 000)
case "$CODE" in
  200|202) ;;
  *) OK=0 ;;
esac

if [ "$OK" -eq 1 ]; then
  for _ in 1 2 3; do
    C=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 \
      -X POST "$APP_URL/register" -H 'Content-Type: application/json' \
      -d '{"student":"check"}' 2>/dev/null || echo 000)
    case "$C" in
      200|202) ;;
      *) OK=0; break ;;
    esac
  done
fi

if [ "$OK" -eq 1 ]; then
  DEPTH2=$(redis-cli LLEN registration:jobs 2>/dev/null | tr -d '\r')
  case "$DEPTH2" in
    ''|*[!0-9]*) OK=0 ;;
    *) [ "$DEPTH2" -lt "$MAX_DEPTH" ] || OK=0 ;;
  esac
fi

if [ "$OK" -eq 1 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
