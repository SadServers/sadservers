# "Rosario": Restore a MySQL database.

## Description
A developer created a database named 'main' but now some data is missing in the database. You need to restore the database using the the dump "/home/admin/backup.sql".<br>
The issue is that the developer forgot the root password for the MariaDB server.<br>
If you encounter an issue while restoring the database, fix it.  

Credit: [Sebastian Segovia](https://www.linkedin.com/in/sebastian-segovia-a7518a228/)

## Test

The database, once restored, has a table named "solution".  

The "Check My Solution" button runs the script /home/admin/agent/check.sh, which you can see and execute.

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# MySQL credentials
MYSQL_USER="root"
DATABASE="main"
TABLE="solution"

# Check if the table exists
if sudo mysql -u"$MYSQL_USER" -e "USE $DATABASE; DESCRIBE $TABLE;" &> /dev/null; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
