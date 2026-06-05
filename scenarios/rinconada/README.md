# "La Rinconada": Elevating privileges

## Description

You are logged in as the user "admin" without general "sudo" privileges.
<br>
The system administrator has granted you limited "sudo" access; this was intended to allow you to read log files.
<br><br>
Your mission is to find a way to exploit this limited sudo permission to gain a full root shell and read the secret file at <i>/root/secret.txt</i>
<br>
Copy the content of <i>/root/secret.txt</i> into the <i>/home/admin/solution.txt</i> file, for example: <kbd>cat /root/secret.txt &gt; /home/admin/solution.txt</kbd> (the "admin" user must be able to read the file).

## Test

As the user "admin", <kbd>md5sum /home/admin/solution.txt</kbd> returns <kbd>52a55258e4d530489ffe0cc4cf02030c</kbd> (we also accept the hash of the same secret string without an ending newline).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if [ -f /home/admin/solution.txt ]; then
  # Checksum must be calculated as the 'admin' user
  HASH=$(md5sum /home/admin/solution.txt | awk '{print $1}')
  if [ "$HASH" == "52a55258e4d530489ffe0cc4cf02030c" ] || [ "$HASH" == "3ca7cb9591e7e86528d3e044dd0bb2d8" ]; then
    echo -n "OK"
    exit 0
  fi
fi

echo -n "NO"
```
