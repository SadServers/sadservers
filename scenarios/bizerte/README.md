# "Bizerte": The Slow Application

## Description

A Python web application running on port 5000 from the <i>/opt</i> directory is experiencing severe performance issues; every request takes more than 5 seconds to complete.
<br>The application is supposed to use the <i>redis-server</i> cache service for speed.
<br><br>Your mission is to diagnose the performance bottleneck and restore the application to its normal, fast response time.
<br><br>Do not change the Python application file <i>slow_app.py</i>.

## Test

<kbd>curl localhost:5000</kbd> returns <i>Data from FAST cache!</i>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

expected="b295b76f72b024defd921280b7b3c112"
actual=$(md5sum /opt/slow_app.py 2>/dev/null | awk '{print $1}')

if [[ "$actual" != "$expected" ]]; then
    echo -n "NO"
    exit 0
fi

response=$(curl -s --max-time 1.5 http://localhost:5000)

if [[ $? -eq 0 && "$response" == *"Data from FAST cache!"* ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
