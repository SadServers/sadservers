# "Tunis": Redis Replication Problem

## Description

A Redis master-replica setup is running on this server, with the master on port 6379 and the replica on port 6380. Both instances show as "connected" when you check their status, but data synchronization has silently broken.
<br><br>
Recent writes to the master don't appear on the replica, even though there are no obvious errors in the logs and both Redis instances appear healthy.
<br><br>
Fix the replication issues so that data written to the master (port 6379) immediately appears on the replica (port 6380) without data loss.
<br><br>
Master: localhost:6379<br>
Replica: localhost:6380<br>
Password: masterpass123
<br><br>
A helper test script is available at <i>/home/admin/test_replication.sh</i>

## Test

The solution will be validated by writing a test key to the master and verifying it appears on the replica within 2 seconds.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Test Redis replication by writing to master and reading from replica
MASTER_PORT=6379
REPLICA_PORT=6380
TEST_KEY="sadservers:check:$(date +%s)"
TEST_VALUE="replication_test_$(date +%N)"
MASTER_PASS="masterpass123"

# Write to master
WRITE_RESULT=$(redis-cli -p $MASTER_PORT -a "$MASTER_PASS" SET "$TEST_KEY" "$TEST_VALUE" 2>/dev/null)

if [ "$WRITE_RESULT" != "OK" ]; then
    # Try without password
    WRITE_RESULT=$(redis-cli -p $MASTER_PORT SET "$TEST_KEY" "$TEST_VALUE" 2>/dev/null)
    if [ "$WRITE_RESULT" != "OK" ]; then
        echo -n "NO"
        exit 0
    fi
    MASTER_PASS=""
fi

MAX_ATTEMPTS=5
ATTEMPT=0
REPLICA_VALUE=""

while [ $ATTEMPT -lt $MAX_ATTEMPTS ] && [ -z "$REPLICA_VALUE" ]; do
    REPLICA_VALUE=$(redis-cli -p $REPLICA_PORT GET "$TEST_KEY" 2>/dev/null)
    if [ -z "$REPLICA_VALUE" ]; then
        REPLICA_VALUE=$(redis-cli -p $REPLICA_PORT -a "$MASTER_PASS" GET "$TEST_KEY" 2>/dev/null)
    fi
    [ -z "$REPLICA_VALUE" ] && sleep 0.1
    ATTEMPT=$((ATTEMPT + 1))
done

# Clean up test key
redis-cli -p $MASTER_PORT -a "$MASTER_PASS" DEL "$TEST_KEY" >/dev/null 2>&1

if [ "$REPLICA_VALUE" = "$TEST_VALUE" ]; then
    REPL_STATUS=$(redis-cli -p $REPLICA_PORT -a "$MASTER_PASS" INFO replication 2>/dev/null | grep -E "master_link_status:up|role:slave")
    
    if echo "$REPL_STATUS" | grep -q "master_link_status:up"; then
        echo -n "OK"
    else
        echo -n "NO"
    fi
else
    echo -n "NO"
fi
```
