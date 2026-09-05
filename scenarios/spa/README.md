# "Spa": The Docker Compose healthcheck that does not heal

## Description

The thermal baths booking API should answer on port <kbd>:5000</kbd>. After last week's outage the previous engineer added a Docker <kbd>HEALTHCHECK</kbd> and <kbd>restart: unless-stopped</kbd> so the stack would recycle itself if the probe failed. The front desk is still down.
<br><br>
The Compose project is in <i>/home/admin/spa</i>. There is a short handover note in that directory.
<br><br>
The booking API application itself is fine when it is running: if you restart the container, <kbd>GET /health</kbd> comes back. You do not need to rewrite or "fix" the API service code. The real gap is recovery — when the API process inside the container dies again, nothing brings the service back on its own. Make the stack recover automatically from that failure so <kbd>/health</kbd> returns <kbd>{"status":"ok"}</kbd> without a manual restart.
<br><br>
The process will not usually die on its own during the exercise. To replay the incident, stop the API worker <i>inside</i> the container (leave the container running): <kbd>docker exec spa-api sh -c 'kill "$(cat /tmp/spa.pid)"'</kbd> — before a fix, <kbd>/health</kbd> stays down. After you add automatic recovery, the same kill should bring <kbd>/health</kbd> back without a manual <kbd>docker restart</kbd>. The recovery must still work after a host reboot (do not leave the API dead on boot).

## Test

<kbd>curl -s http://127.0.0.1:5000/health</kbd> returns <kbd>{"status":"ok"}</kbd> and the <i>spa-api</i> container is <kbd>healthy</kbd>.
<br>
A one-off <kbd>docker restart</kbd> is not enough: after the API worker dies again inside the container, the service must recover on its own.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

body=$(curl -s -m 1 http://127.0.0.1:5000/health 2>/dev/null || true)
if [ "$body" != '{"status":"ok"}' ]; then
  echo -n "NO"
  exit 0
fi

st=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{end}}' spa-api 2>/dev/null || true)
if [ "$st" != "healthy" ]; then
  echo -n "NO"
  exit 0
fi

recover=0

while read -r id; do
  [ -n "$id" ] || continue
  name=$(docker inspect --format '{{.Name}}' "$id" 2>/dev/null || true)
  [ "$name" = "/spa-api" ] && continue
  mounts=$(docker inspect --format '{{range .Mounts}}{{.Source}} {{end}}' "$id" 2>/dev/null || true)
  case "$mounts" in
    *docker.sock*) recover=1 ;;
  esac
done <<EOF
$(docker ps -q 2>/dev/null || true)
EOF

hc=$(docker inspect --format '{{json .Config.Healthcheck.Test}}' spa-api 2>/dev/null || true)
case "$hc" in
  *kill*|*pkill*) recover=1 ;;
esac

p1=$(docker exec spa-api cat /proc/1/cmdline 2>/dev/null | tr '\0' ' ' || true)
case "$p1" in
  *app.py*) recover=1 ;;
esac

if grep -RqsE 'docker[[:space:]]+(compose[[:space:]]+)?restart|health=unhealthy' \
    /etc/systemd/system /etc/cron.d /var/spool/cron /etc/crontab 2>/dev/null; then
  recover=1
fi

if [ "$recover" -eq 1 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
