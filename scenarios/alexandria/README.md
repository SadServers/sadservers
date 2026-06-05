# "Alexandria": The Vanishing Backups

## Description

A critical backup cron job has silently stopped working 3 days ago. The backup script is located at <i>/opt/backup/backup.sh</i> and should create daily backups in <i>/var/backups/daily/</i>, but no new backups have been created recently.
<br><br>
Looking at the backup directory, you can see old backup files from a few days ago, proving the system used to work. However, there are no error emails, no obvious error logs, and the cron service appears to be running normally.
<br><br>
Fix ALL issues preventing the backups from running, so that backups are created successfully and reliably.
<br><br>
Test directory: <i>/var/backups/daily/</i><br>
Backup script: <i>/opt/backup/backup.sh</i>
<br><br>

## Test

The solution will be validated by checking if a backup file has been created in the last 10 minutes.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

BACKUP_DIR="/var/backups/daily"
CURRENT_TIME=$(date +%s)
RECENT_BACKUP_FOUND=0

if [ -d "$BACKUP_DIR" ]; then
    for file in "$BACKUP_DIR"/backup_*.tar.gz; do
        if [ -f "$file" ]; then
            FILE_TIME=$(stat -c %Y "$file" 2>/dev/null)
            TIME_DIFF=$((CURRENT_TIME - FILE_TIME))
            
            if [ "$TIME_DIFF" -lt 600 ]; then
                FILE_SIZE=$(stat -c %s "$file" 2>/dev/null)
                if [ "$FILE_SIZE" -gt 100 ]; then
                    RECENT_BACKUP_FOUND=1
                    break
                fi
            fi
        fi
    done
fi

LOCK_FILE="/opt/backup/backup.lock"
LOCK_EXISTS=0
if [ -f "$LOCK_FILE" ]; then
    LOCK_EXISTS=1
fi

CRON_FIXED=0
if sudo crontab -l -u root 2>/dev/null | grep -q "/opt/backup/backup.sh"; then
    CRON_FIXED=1
fi

if [ "$RECENT_BACKUP_FOUND" -eq 1 ] && [ "$LOCK_EXISTS" -eq 0 ] && [ "$CRON_FIXED" -eq 1 ]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
