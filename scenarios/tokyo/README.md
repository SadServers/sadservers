# "Tokyo": can't serve web file

## Description

There's a web server serving a file <i>/var/www/html/index.html</i> with content "hello sadserver" but when we try to check it locally with an HTTP client like <kbd>curl 127.0.0.1:80</kbd>, nothing is returned. This scenario is not about the particular web server configuration and you only need to have general knowledge about how web servers work.

## Test

<kbd>curl 127.0.0.1:80</kbd> should return: <kbd>hello sadserver</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(curl -s -m 2 127.0.0.1:80)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "hello sadserver" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
