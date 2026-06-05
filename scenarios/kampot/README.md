# Kampot: "A New Port"

## Description

A Python app serving simulated bank data runs as root and listens on port 20280. The app is managed by supervisor and cannot be stopped or reconfigured to use a different port.
<br><br>
An internal legacy monitoring system expects the service to be available on port 80, but the app is hardcoded to 20280 for security and legacy reasons. Your task is to make the service accessible on port 80 locally.

**Endpoints:**

- `/accounts`: List of accounts
- `/transactions`: Recent transactions
- `/balance/<account_id>`: Account balance

**Constraints:**

- You cannot change the app port or stop the service.
- The app must always run as root and restart if stopped.

## Test

<kbd>curl localhost:80/accounts</kbd> returns <kbd>[{"id":1,"name":"Alice","type":"Checking"},{"id":2,"name":"Bob","type":"Savings"},{"id":3,"name":"Charlie","type":"Business"}]</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Check if the app is running and listening on 20280
ss -ltn | grep ':20280' >/dev/null
APP_RUNNING=$?

# check the app endpoint on :80
curl -s http://localhost:80/accounts | grep 'Alice' >/dev/null
ENDPOINT_OK=$?

if [[ "$APP_RUNNING" -eq 0 && "$ENDPOINT_OK" -eq 0 ]]; then
	echo -n "OK"
else
	echo -n "NO"
fi
```
