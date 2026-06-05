# "Kampala": Strange Script Error

## Description

A developer has been working on Linux deployment scripts on their machine and then transferred the files to a Linux server. However, when they try to execute the scripts, they encounter the mysterious error:
<br><br>
<kbd>-bash: cannot execute: required file not found</kbd>
<br><br>
The scripts appear to be syntactically correct, but something is preventing them from executing properly. The developer needs your help to identify and fix the issue so the deployment can proceed.
<br><br>
There are several script files in <i>/home/admin/deploy/</i> that need to be fixed before the deployment process can work correctly.

## Test

All script files in <i>/home/admin/deploy/</i> should execute without the <kbd>cannot execute: required file not found</kbd> error.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash

# Check if all scripts can execute without the ^M error
DEPLOY_DIR="${DEPLOY_DIR:-/home/admin/deploy}"
FAILED=0

for script in "$DEPLOY_DIR"/*.sh; do
    if [ -f "$script" ]; then
        output=$("$script" 2>&1)
        exit_code=$?

        if echo "$output" | grep -q "cannot execute"; then
            FAILED=1
        fi
    fi
done

if [ $FAILED -eq 0 ]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
