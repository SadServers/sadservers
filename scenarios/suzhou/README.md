# "Suzhou": MongoDB replicas!

## Description

A new MongoDB replica set has been setup in the development environment trough <kbd>/home/admin/app/rs0.js</kbd>, however, a variety or errors are showing up when trying to bring it up. You should bring up all the replica servers, get them communicating to each other and make sure the replica set is working as it should.<br><br>
The status of the first replica can be checked via <kbd>systemctl status mongo1</kbd> same for the replicas <kbd>mongo2</kbd> and <kbd>mongo3</kbd>. The logs are also in a separate file for each replica under the directory <kbd>/var/log/mongodb</kbd>. To initilize the replica set again: <kbd>mongosh --file app/rs0.js</kbd></kbd>
<br><br>
<i>Note</i>: The default configuration file <kbd>/etc/mongo.conf</kbd> is not the problem.

## Test

<kbd>mongosh --eval "rs.status()" | grep health</kbd> returns the status of all the replicas
<pre>
      health: 1,
      health: 1,
      health: 1,
</pre>
<br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(mongosh --eval "rs.status()" 2>/dev/null | grep -i 'health: 1' | wc -l)

if [ $res -eq 3 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
