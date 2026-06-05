# "Rio de Janeiro": Do we have another option?

## Description

This scenario server is dedicated to Jenkins, a Java application managed by <i>systemd</i>. Jenkins is failing to start. Troubleshoot and find the problem, then apply the solution so Jenkins runs properly.

## Test

The service must return the string "Sign in - Jenkins" amongst some other html code. You can check with the command <kbd>curl -s localhost:8888/login | grep Jenkins | head -n1</kbd><br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
res=$(curl -s -m 2 127.0.0.1:8888/login | grep Sign | sed 's/^.*<title>//;s/<\/title.*//')

if [ "$res" == "Sign in - Jenkins" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
