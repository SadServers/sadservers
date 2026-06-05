# "Toulon": Denied Lamp

## Description

The security team has asked again Mary and John to implemente more security measures. Unfortunately, this time they have broken the LAMP stack (Apache with PHP) so the frontend is unable get an answer upstream, thus, they need your help again to fix it.
<br><br>
The fixed application should be able to serve the content from the webserver, the problem is a network connectivity, although the logs have valuable informatiion, it has nothing to do with the configuration of the apache server.

## Test

<kbd>curl localhost | head -n1</kbd> returns <kbd>SadServers - LAMP Stack</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(curl -s -m 2 127.0.0.1 | head -n 1)

if [ "$res" == "SadServers - LAMP Stack" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
