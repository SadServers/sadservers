# "Batumi": Troubleshoot "A" cannot connect to "B"

## Description

Hay un servidor web (Caddy) en el puerto HTTP :80 pero <kbd>curl http://127.0.0.1</kbd> no funciona. Descubre lo que pasa y haz los arreglos necesarios y el servidor web te dará una URL.
<br><br>
Nota: como limitación, el fichero <i>/home/admin/db_connector.py</i> no se debe modificar para que el problema se considere bien resuelto.<br>
El servidor web debe responder en la dirección IP 127.0.0.1; no sólamente en "localhost".

----
(To learn the skills to solve this challenge, see <a href="https://docs.sadservers.com/docs/troubleshooting/cant-connect-to-a-service-linux-troubleshooting-guide/" target="_new">Can't Connect to a Service: Linux Troubleshooting Guide</a>)
<br><br>
There is a web server (Caddy) on HTTP port :80 but <kbd>curl http://127.0.0.1</kbd> doesn't work. Find out what's wrong and make the necessary fixes so the web server returns a URL.
<br><br>
Note: as a limitation, the file <i>/home/admin/db_connector.py</i> must not be modified so that the challenge is considered solved properly.<br>
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
