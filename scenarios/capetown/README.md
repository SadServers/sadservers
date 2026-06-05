# "Cape Town": Nginx borked

## Description

There's an Nginx web server installed and managed by systemd. Running <kbd>curl -I 127.0.0.1:80</kbd> returns
<kbd>curl: (7) Failed to connect to localhost port 80: Connection refused</kbd> , fix it so when you curl you get the default Nginx page.

## Test

<kbd>curl -Is 127.0.0.1:80|head -1</kbd> returns <kbd>HTTP/1.1 200 OK</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(curl -Is 127.0.0.1:80|head -1)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "HTTP/1.1 200 OK" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
