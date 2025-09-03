# "Monapaya": Security Snag. The Trials of John and Mike

## Description

John and Mike are working on a Golang web application, and the security team has asked them to implement security measures. They have been tasked with the following:
- The application must communicate only over HTTPS.
- The application should only have access to the necessary files. Certificate and static files
- The application should be rate-limited to 10 requests per second.
- The application should run with a non-root user.

John and Mike tried their best; unfortunately, they have broken the application while adding security measures, and it no longer functions. They need your help to fix it.

The fixed application should be able to:
- Allow clients to communicate with the application over HTTPS without ignoring any checks.
- Allow clients to make at most 10 requests per second.
- Serve static files.

## Test

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

set -Eeuo pipefail

## validate application connectivity and file access
_err() {
	echo -n 'NO'
	exit 1
}

trap "_err" ERR

main() {
	systemctl is-active webapp &>/dev/null

	curl -sLo /dev/null https://webapp:7000/users.html

	curl -sL https://webapp:7000/healthcheck.html | grep -q 'Health'

	echo -n "OK"
}

main
```
