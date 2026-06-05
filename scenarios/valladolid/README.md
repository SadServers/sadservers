# "Valladolid": Cleaner not cleaning

## Description

The systemd service <i>log-cleaner.service</i> is supposed to be run manually (not a timer or cron job) and delete log files older than 7 days in the <i>/var/log/app</i> directory.
<br><br>
The service runs successfully (exit code 0), but no logs are ever deleted.
<br><br>
Fix the service and/or the script so that <i>old_data.log</i> (older than 7 days) is deleted, but <i>recent_data.log</i> is preserved.
<br><br>
If you accidentally delete the wrong files while debugging, run <kbd>~/reset_logs.sh</kbd> to restore them.

## Test

Running <kbd>sudo systemctl restart log-cleaner</kbd> deletes the file <i>/var/log/app/old_data.log</i> but not <i>/var/log/app/recent_data.log</i>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

OLD_LOG="/var/log/app/old_data.log"
NEW_LOG="/var/log/app/recent_data.log"

sudo systemctl restart log-cleaner

# 1. The old file MUST be deleted
if [ -f "$OLD_LOG" ]; then
  echo -n "NO"
  exit
fi

# 2. The new file MUST still exist
if [ ! -f "$NEW_LOG" ]; then
  echo -n "NO" 
  exit
fi

echo -n "OK"
```
