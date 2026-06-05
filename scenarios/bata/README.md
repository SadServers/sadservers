# "Bata": Find in /proc

## Description

A spy has left a password in a file in <i>/proc/sys</i> . The contents of the file start with <i>"secret:"</i> (without the quotes).
<br><br>Find the file and save the word after "secret:" to the file <i>/home/admin/secret.txt</i> with a newline at the end (e.g. if the file contents were "secret:password" do: <kbd>echo "password" > /home/admin/secret.txt</kbd>).
<br><br>
(Note there's no root/sudo access in this scenario).

## Test

Running `md5sum /home/admin/secret.txt` returns `a7fcfd21da428dd7d4c5bb4c2e2207c4`  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/secret.txt |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "a7fcfd21da428dd7d4c5bb4c2e2207c4" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
