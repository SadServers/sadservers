# "Melbourne": WSGI with Gunicorn

## Description

There is a Python <a href="https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface">WSGI</a> web application file at <i>/home/admin/wsgi.py</i> , the purpose of which is to serve the string "Hello, world!". This file is served by a <a href="https://docs.gunicorn.org/en/stable/">Gunicorn</a> server which is fronted by an nginx server (both servers managed by systemd). So the flow of an HTTP request is: Web Client (curl) -> Nginx -> Gunicorn -> wsgi.py . The objective is to be able to curl the localhost (on default port :80) and get back "Hello, world!", using the current setup.

## Test

<kbd>curl -s http://localhost</kbd> returns <kbd>Hello, world!</kbd> (serving the wsgi.py file via Gunicorn and Nginx)

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(curl -s --unix-socket /run/gunicorn.sock http://localhost)
res=$(echo $res|tr -d '\r')

if [[ "$res" != "Hello, world!" ]]
then
  echo -n "NO"
  exit
fi

res=$(curl -s http://localhost)
res=$(echo $res|tr -d '\r')
if [[ "$res" = "Hello, world!" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
