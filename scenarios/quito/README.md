# "Quito": Control One Container from Another

## Description

You have a running container named <i>docker-access</i>. Another container <i>nginx</i> is present but in a stopped state. Your goal is to start the nginx container from inside the docker-access container.
<br><br>
You must not start the nginx container from the host system or any other container that is not <i>docker-access</i>. You can restart this <i>docker-access</i> container.

## Test

Executing `docker ps` inside the docker-access container: `docker exec docker-access docker ps` succeeds.  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

nginx_status=$(docker inspect -f '{{.State.Running}}' nginx)

if [[ "$nginx_status" != "true" ]]; then
  echo -n "NO"
  exit
fi

# Try to execute `docker ps` inside the docker-access container
docker exec docker-access docker ps &>/dev/null

# Check the exit status of the last command
if [[ $? -eq 0 ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
