# "Hanoi": Find the Multitasking Users

## Description

The Hanoi office has a Linux server with a large number of user accounts and groups. The system administrators need to identify which users belong to multiple groups for better access management.  

Given two files, `users.txt` and `groups.txt`, create a new file `/home/admin/multi-group-users.txt` containing the usernames of users who belong to more than one group, one username per line, sorted alphabetically.  

The `users.txt` file contains a list of usernames, one per line.
The `groups.txt` file contains group names and their members, in the format `group_name:user1,user2,user3`.

## Test

Running `md5sum /home/admin/multi-group-users.txt` returns `dc0ae86caae7125d21df03a0ab29d8ae`  


The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.  

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if [ ! -f "/home/admin/multi-group-users.txt" ]; then
  echo -n "NO"
  exit
fi

res=$(md5sum /home/admin/multi-group-users.txt |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "dc0ae86caae7125d21df03a0ab29d8ae" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
