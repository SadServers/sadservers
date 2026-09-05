# "Salta": Docker container won't start

## Description

There's a "dockerized" Node.js web application in the <kbd>/home/admin/app</kbd> directory. Create a Docker container so you get a web app on port <i>:8888</i> and can <i>curl</i> to it.
<br><br>
Right now <kbd>curl localhost:8888</kbd> does not return the app response — something else may already be answering on that port. For the solution to be valid, there should be only one running Docker container (any image/container name is fine).
<br><br>
NOTE: The base image <i>node:15.7-alpine</i> declared in Dockerfile is present locally (<kbd>docker images</kbd>).
<br><br>
NOTE: nginx service is not needed in this server.

## Test

<kbd>curl localhost:8888</kbd> returns exactly <kbd>Hello World!</kbd> from a single running container that publishes host port <kbd>8888</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

## Clues

<b>1.</b> Inspect: <kbd>docker images; docker ps -a</kbd>. There is a failed container and a pre-built <kbd>app</kbd> image.
<br><br>

<b>2.</b> Check logs: <kbd>docker logs app</kbd>. The Dockerfile <kbd>CMD</kbd> has a typo — it runs <kbd>serve.js</kbd> but the file is <kbd>server.js</kbd>.
<br><br>


<b>3.</b> Fix the typo in the Dockerfile (<kbd>serve.js</kbd> → <kbd>server.js</kbd>).
<br><br>

<b>4.</b> <kbd>EXPOSE</kbd> in Dockerfile is mostly documentation (it only auto-maps with <kbd>-P</kbd>, which picks a random host port — not enough here). You do not need to change it, but updating it to <kbd>8888</kbd> is good practice; still publish with <kbd>-p 8888:8888</kbd>.
<br><br>

<b>5.</b> Rebuild the Docker image from <i>/home/admin/app</i>:
<br>
<kbd>docker build -t app .</kbd>
<br><br>

<b>6.</b> Nginx is bound to host <kbd>:8888</kbd> (the leftover <kbd>app</kbd> container is stopped). Stop nginx and remove that container before the new run:
<br>
<kbd>sudo systemctl stop nginx</kbd>
<br>
<kbd>docker rm -f app</kbd>
<br><br>
(Next Clue reveals the last solution step)
<br><br>


<b>7.</b> <kbd>docker run -d --name app -p 8888:8888 app</kbd>


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(curl -s -m 2 localhost:8888 2>/dev/null || true)
n=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
pub=$(docker ps --filter publish=8888 -q 2>/dev/null | wc -l | tr -d ' ')

if [[ "$res" == "Hello World!" && "$n" == "1" && "$pub" == "1" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
