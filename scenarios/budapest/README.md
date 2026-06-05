# "Budapest": User Creation

## Description

Given the file <kbd>/home/admin/user_list.txt</kbd> you must create all the users specified in the file with their corresponding passwords.
<br><br><i>The entries in the <kbd>user_list.txt</kbd> file are stored as <kbd>username;password</kbd></i>

## Test

All users are created with the right password.<br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

line=$(shuf -n 1 /home/admin/user_list.txt)
user=$(echo "$line" | cut -d ';' -f 1)
pass=$(echo "$line" | cut -d ';' -f 2)

shadow_line=$(sudo grep "^$user:" /etc/shadow)
[ -z "$shadow_line" ] && { echo -n "NO"; exit 0; }

hash=$(echo "$shadow_line" | cut -d ':' -f2)

salt=$(echo "$hash" | cut -d '$' -f3)

computed=$(openssl passwd -1 -salt "$salt" "$pass")

[ "$computed" != "$hash" ] && { echo -n "NO"; exit 0; }

echo -n "OK"
exit 0
```
