# "Taipei": Come a-knocking

## Description

There is a web server on port :80 protected with <a href="https://en.wikipedia.org/wiki/Port_knocking" target="_new">Port Knocking</a>. Find the one "knock" needed (sending a SYN to a single port, not a sequence) so you can <kbd>curl localhost</kbd>.

## Test

Executing <kbd>curl localhost</kbd> returns a message with md5sum <i>fe474f8e1c29e9f412ed3b726369ab65</i>. (Note: the resulting md5sum includes the new line terminator: <kbd>echo $(curl localhost)</kbd>)


<b>check.sh</b>

```
#!/bin/bash
res=$(curl -s localhost)
res=$(echo $res|tr -d '\r')
checksum=$(echo $res| md5sum| awk '{print $1}')

if [[ "$checksum" = "fe474f8e1c29e9f412ed3b726369ab65" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
