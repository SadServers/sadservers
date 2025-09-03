# "Atrani": Modify a SQlite3 Database

## Description

A developer created a script _/home/admin/readdb.py_ that tests access to a database.
Without modifying the readdb.py file, change the database so that running the script returns the string "John Karmack".


## Test

Running _/home/admin/readdb.py_ returns "John Karmack".  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/readdb.py |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" != "c4d5e1d8c4efbd3b70ab5569e2058157" ]]
then
  echo -n "NO"
  exit 1
fi

source /etc/profile
res=$(/home/admin/readdb.py)

if [[ "$res" = "John Karmack" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
