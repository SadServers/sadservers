# "Salta": Docker container won't start.

## Description

There's a "dockerized" Node.js web application in the <kbd>/home/admin/app</kbd> directory. Create a Docker container so you get a web app on port <i>:8888</i> and can <i>curl</i> to it. For the solution to be valid, there should be only one running Docker container.

## Test

<kbd>curl localhost:8888</kbd> returns <kbd>Hello World!</kbd> from a running container.

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(curl -s localhost:8888)
res2=$(sudo docker ps --format "{{.Ports}}" |grep -c '8888->8888/tcp')
res2=$(echo $res2|tr -d '\r')

if [[ "$res" = "Hello World!" && "$res2" = "1" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
