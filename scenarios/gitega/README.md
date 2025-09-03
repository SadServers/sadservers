# "Gitega": Find the Bad Git Commit

## Description

The directory at _/home/admin/git_ has a Git repository with a Golang program and a test for it.  

To execute the test, from this "git" directory run: `go test`. The last (current HEAD) commit fails the test. Suppose the first commit passed the test.  

Find the (long hash) commit that first broke the test and enter it in the _/home/admin/solution_ file. For example: `echo 9e80a7eb1b09385e93ab4a76cb2c93beec48fd9f > /home/admin/solution`

## Test

Doing `md5sum /home/admin/solution` returns `f7db1bb6b7bfcd66a4eb66782804b39d`.  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/solution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "f7db1bb6b7bfcd66a4eb66782804b39d" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
