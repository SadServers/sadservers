# Tokelau

## Description

(No description available in source repository.)

## Test

The "Check My Solution" button runs the script `/home/admin/agent/check.sh`, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# file must exist and be non-empty
if [ -s /home/admin/.bash_history ]; then
    history -r /home/admin/.bash_history
    history |grep -q "foo"

    if [ $? -eq 1 ]; then
        echo -n "OK"
    else
        echo -n "NO"
    fi
else
    echo -n "NO"
fi
```
