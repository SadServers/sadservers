# "Atlantis": Not found

## Description

There is a small "C" application in the <i>/home/admin/app</i> directory. Create the Docker container "app" with a small footprint and minimalistic so you get a <kbd>hello</kbd> binary that returns a greeting in Atlantean (Docker multi-stage build). The binary application is automatically called when running <kbd>docker run app</kbd>

## Test

<kbd>docker run app</kbd> returns <kbd>SOO-puhk</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(docker run app)

if [ "$res" == "SOO-puhk" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
