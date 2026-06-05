# "San Juan": mucho Traefik

## Description

There is a Traefik load balancer that must be up and running. The server and the backend services are managed by Docker Compose. Running <kbd>curl -s app.sadserver | head -n1</kbd> must return the host ID of one of the backend servers, running the command again must return a new host ID. The server seems to be working some times, some others fails or just times out.
<br><br>
The round-robin configuration should make the webserver iterate through the back-end servers.

## Test

<kbd>curl -s app.sadserver | head -n1</kbd> returns something like <kbd>Hostname: <host_id></i></kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=0
for i in {1..4}; do 
  id=$(curl -s app.sadserver -m 1 | head -n 1 | cut -d ' ' -f1)
  if [ "$id" == "Hostname:" ]; then
	  res=$((res + 1))
  fi
done

if [ $res -eq 4 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
