# "Constanta": Jumping Frog

## Description

This is a "hacking" or Capture The Flag challenge. You need to copy the message at `/home/user3/secret.txt` into the `/home/admin/solution.txt` file.

## Test

Running `md5sum /home/user10/secret.txt` returns the hash `7fe16554d0b326309d980314cebc2994`  

The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/solution.txt | awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "7fe16554d0b326309d980314cebc2994" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
