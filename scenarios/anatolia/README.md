# "Anatolia": compromised server

## Description

This web server has been compromised and is not serving the home page anymore, those troubleshooting skills you have as DevOps are urgently needed to solve the mystery of the missed home page and restore the integrity of the server.
<br><br>
<i>Note</i>: The default configuration files under <kbd>/etc/apache2</kbd> are not the problem.
<br><br>
This scenario is based on a real server that was "hacked". Ideally you'd recover from infrastrucrure as code playbooks and clean data backups on a new server with the vulnerabilities fixed. Instead, in this exercise you are asked to clean manually the compromised server, restore it to a working condition and ideally, find how the server was broken into. The solution test only checks that the web service is working.

## Test

<kbd>curl localhost</kbd> must return <kbd>SadServer - Anatolia</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=0
for i in {1..3}; do
  str=$(curl -s localhost)
  if [ "$str" == "SadServer - Anatolia" ]; then
    res=$((res + 1))
  fi
done

if [ $res -eq 3 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
