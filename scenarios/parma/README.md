# "Parma": Debugging Terraform Issues

## Description

This host publishes a machine-readable status marker using Terraform with a local backend. The project lives in <i>/home/admin/infra/</i> and should write <i>/var/local/platform-status.txt</i>.
<br><br>
After a refactor, <kbd>terraform plan</kbd> and <kbd>terraform apply</kbd> no longer succeed, and the status file is missing or stale.
<br><br>
Fix the Terraform project and apply it so the marker is published again.
<br><br>
(Note: Internet access is not needed).

## Test

The first line of <i>/var/local/platform-status.txt</i> is <kbd>SadServers - Parma OK</kbd>.
<br><br>
Running <kbd>terraform plan</kbd> in <i>/home/admin/infra/</i> reports no changes pending (clean state).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() {
  echo -n "NO"
  exit 0
}

INFRA=/home/admin/infra
STATUS=/var/local/platform-status.txt

line=$(head -n 1 "$STATUS" 2>/dev/null | tr -d '\r')
if [ "$line" != "SadServers - Parma OK" ]; then
  fail
fi

if ! env PATH="/usr/local/bin:${PATH}" bash -c "cd '$INFRA' && terraform plan -detailed-exitcode -input=false" >/dev/null 2>&1; then
  fail
fi

echo -n "OK"
```
