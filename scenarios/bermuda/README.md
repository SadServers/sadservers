# "Bermuda": Command not found

## Description

While working with a distro with a very small footprint, we just found out that there are some basic commands not present, this was supposed to be a security feature, after all this is just a small server, however, the web content was not deployed. Your task is to decompress the file <i>/home/admin/web.zip</i> and move the file home.html in it to <kbd>/var/www/html/index.html</kbd>

## Test

The service must return the string "Homepage". You can check with the command <kbd>curl -s localhost</kbd><br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
res=$(curl -s -m 2 127.0.0.1 | head -n1)

if [ "$res" == "Homepage" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
