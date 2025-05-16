# Bangalore: Envoy Panics

## Description

There is an Envoy proxy routing traffic to two unhealthy backend services but the Envoy container won't start. Your first task is to fix that.  

When the number of healthy backends falls under a panic threshold (default 50%), Envoy enters a _panic mode_ and it will either send traffic to all upstream hosts or to none at all.    

We are simulating this condition by returning an HTTP 503 status code from the _/health_ endpoint in both backends. In our case Envoy is sending traffic to all upstream services.  

Your second task is to change the panic Envoy behaviour so that it does not route any traffic to unhealthy services and instead Envoy returns "no healthy upstream". (Do not change anything in the backend services). There can also be other Envoy configuration issues you need to fix.


## Test

Running `curl localhost:10000` should return `no healthy upstream`.  

The "Check My Solution" button runs the script `/home/admin/agent/check.sh`, which you can see and execute.  

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Function to check if a container is running
check_container_running() {
    local container_name=$1
    if [ -z "$(docker ps -q -f name=^/${container_name}$)" ]; then
        echo -n "NO"
        exit 0
    fi
}

# Check if express1 and express2 containers are running
check_container_running "express1"
check_container_running "express2"

# Test if Envoy returns "no healthy upstream" when backends are unhealthy
response=$(curl -s --max-time 2 http://localhost:10000)

if [[ "$response" == *"no healthy upstream"* ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
