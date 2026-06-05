# "Warsaw": Promethues can't scrape the webserver

## Description

A developer created a golang application that is exposing the <i>/metrics</i> endpoint. They have a problem with scraping the metrics from the application. They asked you to help find the problem.
<br><br>Full source code of the application is available at the <i>/home/admin/app</i> directory.
<br><br>
Credit <a href="https://www.devkblaz.com/" target="_blank">Kamil Błaż</a>

## Test

The endpoint http://localhost:9000/metrics should return HTTP code 200.  

The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash

HTTP_CODE_9000=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000/metrics)
if [[ "${HTTP_CODE_9000}" -eq 200 ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
