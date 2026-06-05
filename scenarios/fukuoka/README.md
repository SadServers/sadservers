# "Fukuoka": Forbidden Association

## Description

There's a web server running on this host but <kbd>curl localhost</kbd> returns the default <i>404 Not Found</i> page.<br><br>
Fix the issue so that a file is served correctly and the message <i>Welcome to the Real Site!</i> is returned.

## Test

Running <kbd>curl localhost</kbd> should return HTTP 200 with the message <i>Welcome to the Real Site!</i>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash

status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$status_code" -eq 200 ]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
