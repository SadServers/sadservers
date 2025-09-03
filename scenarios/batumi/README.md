# "Batumi": Troubleshoot "A" cannot connect to "B"

## Description

There is a web server (Caddy) on HTTP port :80 but `curl http://127.0.0.1` doesn't work. Find out what's wrong and make the necessary fixes so the web server returns a URL.  

Note: as a limitation, the file _/home/admin/db_connector.py_ must not be modified so that the challenge is considered solved properly.
The web server has to respond on the IP address 127.0.0.1; not only on "localhost".

## Test

The command `curl http://127.0.0.1` returns a URL address.  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/db_connector.py |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" != "8844af8942f5ef7aaf5cde312176b512" ]]
then
  echo -n "NO"
  exit 1
fi


res=$(curl -s -m 1 http://127.0.0.1:80)
res=$(echo $res|tr -d '\r')
res=$(echo $res|md5sum |awk '{print $1}')

if [[ "$res" != "8304588fc545d656d9090a1883a6883e" ]]
then
  echo -n "NO"
else
  echo -n "OK"
fi
```
