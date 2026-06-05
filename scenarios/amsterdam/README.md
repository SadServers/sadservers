# Amsterdam: Cron Hijack

## Description

You are logged in as the user <i>admin</i>. A cron job (not a systemd timer) appears to be running as <i>root</i> every minute, related to a health check.<br>This server has as root's path <i>/home/admin:/usr/local/bin:/usr/bin:/bin</i>
<br><br>
Your mission is to find the running cron job, and use it to exploit the server so you can read the secret file at <i>/root/secret.txt</i>
<br><br>
Save the secret string from the secret file to the file <i>/home/admin/solution.txt</i>.

## Test

<kbd>cat /home/admin/solution.txt</kbd> displays the same string that is in <i>/root/secret.txt</i>, with <kbd>md5sum /home/admin/solution.txt</kbd> returning <kbd>c6ef5d3ea5e937ae56f8635f91cc727a</kbd> (the solution string without an ending newline is also accepted)
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if [ -f /home/admin/solution.txt ]; then
  HASH=$(md5sum /home/admin/solution.txt | awk '{print $1}')
  if [ "$HASH" = "c6ef5d3ea5e937ae56f8635f91cc727a" ] || [ "$HASH" = "dcd8325d95fd5facafe0a959bbf09fcd" ]; then
    echo -n "OK"
    exit
  else
    echo -n "NO"
    exit
  fi
else
  echo -n "NO"
fi
```
