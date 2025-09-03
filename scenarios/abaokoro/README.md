# "Abaokoro": Restore MySQL Databases Spooked by a Ghost

## Description
There are three databases that need to be restored. You need to create three databases called "first", "second" and "third" and restore the databases using the file "/home/admin/dbs_to_restore.tar.gz".  

If you encounter an issue while restoring the database, fix it.  

Credit: [Sebastian Segovia](https://www.linkedin.com/in/sebastian-segovia-a7518a228/)

## Test

All databases, once restored, have a table named "foo".  

The "Check My Solution" button runs the script /home/admin/agent/check.sh, which you can see and execute. 

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# MySQL credentials
MYSQL_USER="root"
DATABASES=("first" "second" "third")
TABLE="foo"

# Initialize a variable to track if the table is found in all databases
table_found=true

for DATABASE in "${DATABASES[@]}"; do
    # Check if the table exists
    if ! sudo mysql -u"$MYSQL_USER" -e "USE $DATABASE; DESCRIBE $TABLE;" &> /dev/null; then
        table_found=false
        break
    fi
done

if $table_found; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
