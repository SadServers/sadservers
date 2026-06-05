# "Nuuk": More SSH Troubles

## Description

(<b>NOTE</b>: if you are a Pro user, you cannot SSH directly into this VM; click the "Open the Server Terminal" button to use the web browser instead).
<br><br>
SSH seems broken in this server. The user <i>admin</i> has an <i>id_ed25519</i> SSH key pair in their <i>~/.ssh</i> directory with the public key in <i>~/.ssh/authorized_keys</i> but <kbd>ssh 127.0.0.1</kbd> won't work.

## Test

You can ssh locally, i.e. <kbd>ssh admin@127.0.0.1</kbd> works.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@127.0.0.1 "whoami" 2>/dev/null)

if [ "$res" == "admin" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
