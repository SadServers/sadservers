# "Annapurna": High privileges

## Description

You are logged in as the user <i>admin</i>.
<br><br>
You have been tasked with auditing the admin user privileges in this server; "admin" should not have sudo (root) access.
<br><br>
Exploit this server so you as the admin user can read the file <i>/root/mysecret.txt</i>
<br>
Save the content of <i>/root/mysecret.txt</i> to the file <i>/home/admin/mysolution.txt</i> , for example: <kbd>echo "secret" > ~/mysolution.txt</kbd>

## Test

Running <kbd>md5sum /home/admin/mysolution.txt</kbd> returns <kbd>47ee165a2262476f6866902a93f2a41d</kbd>. (We also accept the md5sum of the same file without a newline at the end).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if [ -f /home/admin/mysolution.txt ]; then
  HASH=$(md5sum /home/admin/mysolution.txt | awk '{print $1}')
  if [[ "$HASH" == "47ee165a2262476f6866902a93f2a41d" || "$HASH" == "938ca1edf6cdaa7a19bdc9d3257dd2e3" ]]; then
    echo -n "OK"
    exit 0
  fi
fi

echo -n "NO"
```
