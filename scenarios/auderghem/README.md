# "Auderghem": container can't communicate with each other!

## Description

I have container nginx proxy listen en port 80.
I tried to redirect the traffic to 2 other containers statichtml1 statichtml2 and its not working.
please fix the problem

**IMPORTANT.** : you can restart all container but don't **stop** and **remove** it.

## Test

all container must be running.<br/>
nginx listen on port 80 <br/>
**curl response :**<br/>
curl http://localhost   -> Welcome to nginx <br/>
curl http://localhost/1 -> HelloWorld;1 <br/>
curl http://localhost/2 -> HelloWorld;2 <br/>


**check.sh**

```bash
#!/usr/bin/bash

docker inspect nginx       | jq -e '.[].State.Status == "running"' > /dev/null || { echo "NO"; exit 1; }
docker inspect statichtml1 | jq -e '.[].State.Status == "running"' > /dev/null || { echo "NO"; exit 1; }
docker inspect statichtml2 | jq -e '.[].State.Status == "running"' > /dev/null || { echo "NO"; exit 1; }

docker inspect nginx | jq -e '.. | .PortBindings?."80/tcp"? // empty'    > /dev/null || { echo "NO"; exit 1; }
docker inspect nginx | jq -e '[.. | .NetworkID? // empty] | length == 2' > /dev/null || { echo "NO"; exit 1; }

curl -m 3 -sI http://localhost   | awk -F': ' '/^Server/ {print $2}'  | grep -m 1 -Eo "nginx" > /dev/null || { echo "NO"; exit 1; }
curl -m 3 -sI http://localhost/1 | awk -F': ' '/^Server/ {print $2}'  | grep -m 1 -Eo "nginx" > /dev/null || { echo "NO"; exit 1; }
curl -m 3 -sI http://localhost/2 | awk -F': ' '/^Server/ {print $2}'  | grep -m 1 -Eo "nginx" > /dev/null || { echo "NO"; exit 1; }

curl -m 3 -s  http://localhost   | grep -m 1 -Eo "Welcome to nginx" > /dev/null || { echo "NO"; exit 1; }
curl -m 3 -s  http://localhost/1 | grep -m 1 -Eo "HelloWorld;1"     > /dev/null || { echo "NO"; exit 1; }
curl -m 3 -s  http://localhost/2 | grep -m 1 -Eo "HelloWorld;2"     > /dev/null || { echo "NO"; exit 1; }

echo "OK";
exit 0
```
