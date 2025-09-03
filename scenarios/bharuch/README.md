# Bharuch: "Lost in Translation"

## Description

There's a Docker container that runs a web server on port 3000, but it's not working.  

Using the tooling and resources provided in the server, make the container run correctly.


## Test

`curl http://localhost:3000` should return "salutations!"  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Check if the service on localhost:3000 is up and responding
curl_url="http://localhost:3000"
if curl --silent --head --fail "$curl_url" > /dev/null; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
