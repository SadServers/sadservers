# "Modena": Ansible Deploy Won't Publish

## Description

This host publishes an internal status page by running Ansible locally against the Docker container <i>status-app</i> (port <kbd>8888</kbd> on localhost maps to the container's HTTP port).
<br><br>
The playbook tree lives in <i>/home/admin/deploy/</i>. After a refactor, <kbd>ansible-playbook site.yml</kbd> no longer leaves a working status endpoint — <kbd>curl http://localhost:8888/</kbd> does not return the expected line.
<br><br>
Fix the Ansible project and run the playbook successfully so the status page is served from the container.

## Test

<kbd>curl http://localhost:8888/</kbd> returns a first line of <kbd>SadServers - Modena OK</kbd>.
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

if ! docker ps --format '{{.Names}}' | grep -qx 'status-app'; then
  fail
fi

line=$(curl -s -m 2 http://127.0.0.1:8888/ | head -n 1 | tr -d '\r')
if [ "$line" != "SadServers - Modena OK" ]; then
  fail
fi

echo -n "OK"
```
