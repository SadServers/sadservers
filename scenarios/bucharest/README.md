# "Bucharest": Connecting to Postgres

## Description

A web application relies on the PostgreSQL 13 database present on this server. However, the connection to the database is not working. Your task is to identify and resolve the issue causing this connection failure. The application connects to a database named <i>app1</i> with the user <i>app1user</i> and the password <i>app1user</i>.<br><br>
Credit <a href="https://twitter.com/PykPyky" target="_blank">PykPyky</a>

## Test

Running <kbd>PGPASSWORD=app1user psql -h 127.0.0.1 -d app1 -U app1user -c '\q'</kbd> succeeds (does not return an error).


<b>check.sh</b>

```bash
#!/bin/bash
# # DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Set the password and try to connect to the postgres server
PGPASSWORD=app1user psql -h 127.0.0.1 -d app1 -U app1user -c '\q' 2>/dev/null
STATUS=$?

# Check the exit status
if [ ${STATUS} -eq 0 ]; then
    echo -n "OK"
else
    echo -n "NO"
fi

```
