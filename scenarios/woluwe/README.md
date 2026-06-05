# "Woluwe": Too many images

## Description

A pipeline created a lot of Docker images locally for a web app. All these images except for one contain a typo introduced by a developer: there's an incorrect image instruction to pipe "HelloWorld" to "index.htmlz" instead of using the correct "index.html"<br/>
Find which image doesn't have the typo (and uses the correct "index.html"), tag this correct image as "prod" (rather than fixing the current prod image) and then deploy it with <kbd>docker run -d --name prod -p 3000:3000 prod</kbd> so it responds correctly to HTTP requests on port :3000 instead of "404 Not Found".

## Test

<kbd>curl http://localhost:3000</kbd> should respond with <kbd>HelloWorld;529</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash

prodmd5="no-md5-set"

docker inspect prod       | jq -e '.[].State.Status == "running"'       > /dev/null     || { echo "NO"; exit 1; }
docker inspect prod       | jq -e '.. | .PortBindings?."3000/tcp"? // empty'    > /dev/null     || { echo "NO"; exit 1; }
docker inspect prod       | jq -e '.[].Config.Image == "prod"'          > /dev/null     || { echo "NO"; exit 1; }
curl -s -m 3 http://localhost:3000  | grep -m 1 -Eo "HelloWorld;529"            > /dev/null     || { echo "NO"; exit 1; }
curl -s -m 3 http://localhost:3000/index.data | md5sum | grep -Eo "$prodmd5"    > /dev/null     || { echo "NO"; exit 1; }

echo "OK";
exit 0
```
