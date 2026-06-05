# "Cairo": Time for a Timer

## Description

A critical health check script at <i>/opt/scripts/health.sh</i> is supposed to run every 10 seconds. This check is triggered by a systemd timer.
<br>
The script's job is to check the local Nginx server and write its status (e.g., "STATUS: OK") to the log file at /var/log/health.log.
<br>
The log file is not being updated, and it appears the health check is failing.
<br><br>
Find out why the health check system is broken and fix it. The check will pass once the <i>/var/log/health.log</i> file is being correctly updated by the timer with a <kbd>STATUS: OK</kbd> message.

## Test

The <i>/opt/scripts/health.sh</i> script writes <kbd>STATUS: OK</kbd> to <i>/var/log/health.log</i> every 10 seconds.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

/opt/scripts/health.sh &> /dev/null
SCRIPT_WORKS=$?

if systemctl is-enabled --quiet health.timer; then
  TIMER_ENABLED=0
else
  TIMER_ENABLED=1
fi

if systemctl is-active --quiet health.timer; then
  TIMER_ACTIVE=0
else
  TIMER_ACTIVE=1
fi

if [ $SCRIPT_WORKS -eq 0 ] && [ $TIMER_ENABLED -eq 0 ] && [ $TIMER_ACTIVE -eq 0 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
