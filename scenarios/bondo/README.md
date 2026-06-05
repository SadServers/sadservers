# "Bondo": Split my pile!

## Description

A developer wants to run a program that splits their pile of their data into compressed parts for efficient transport across their network. Unfortunately when the tool runs it never completes.
<br><br>
The application binary in question is called <i>bondo</i> located in <i>/home/admin/bondo</i>.
<br><br>
Run it, then debug and help the developer find the issue.

## Test

Executing <kbd>/home/admin/bondo</kbd> as <i>admin</i> returns <kbd>part files generation completed!</kbd>.
<br><br>
The file <i>/etc/fstab</i> has not been modified and the solution would work on reboot.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

sudo mount -a
expected="1149fdd0fbca15404ea0974e7c3d60bf"
actual=$(tail -1 /etc/fstab|md5sum 2>/dev/null | awk '{print $1}')

if [[ "$actual" != "$expected" ]]; then
  echo -n "NO"
  exit 0
fi


/home/admin/bondo  > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -n "NO"
else
  echo -n "OK"
fi
```
