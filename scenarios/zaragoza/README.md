# "Zaragoza": Test changing critical files

## Description

The goal is to make the script <i>/home/admin/agent/check.sh</i> return <i>OK</i>, without editing the original <i>/etc/hosts</i> file.
<br><br>
Think of testing changes in the critical directory /etc in a safe way. In this case, adding "127.0.0.1 my.local.test" to /etc/hosts .
<br><br>
There would be many ways of trying to do this with "sudo" access, like the usual procedure of making a copy of the config file, editing there and copying or renaming back to the original file. In our case, to avoid all those simple solutions, there is no general "sudo" privileges in this scenario (but there may be for some commands).

## Test

The string <i>my.local.test</i> is in <i>/etc/hosts</i>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if grep -q 'my.local.test' /etc/hosts; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
