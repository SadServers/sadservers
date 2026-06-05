# "Madrid": exploiting capabilities

## Description

You are logged in as the <i>admin</i> user without sudo privileges.
<br><br>
A secret string is in the file <i>/root/flag.txt</i> and you don't have permission to read it directly.
<br><br>
However, a standard system binary has been misconfigured with a "hidden" capability that allows it to bypass file permissions.
<br><br>
Your mission is to find the misconfigured binary and use it to copy the content of <i>/root/flag.txt</i> into the file <i>/home/admin/flag.txt</i>.

## Test

<kbd>cat /home/admin/flag.txt</kbd> displays the same string that is in <i>/root/flag.txt</i>, with <kbd>md5sum /home/admin/flag.txt</kbd> returning <kbd>a43d338b0fc1dfb0c6425aa55e24c8c6</kbd> (the solution string without an ending newline is also accepted)
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

USER_FILE="/home/admin/flag.txt"

if [ -f "$USER_FILE" ]; then
  # Calculate the MD5 hash of the user's file
  USER_HASH=$(md5sum "$USER_FILE" | awk '{print $1}')

  if [ "$USER_HASH" == "a43d338b0fc1dfb0c6425aa55e24c8c6" ] || [ "$USER_HASH" == "d452f5290a8db51a3ac390c56d811fae" ]; then
    echo -n "OK"
    exit
  fi
fi

echo -n "NO"
```
