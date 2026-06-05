# "Saint John": what is writing to this log file?

## Description

A developer created a testing program that is continuously writing to a log file <i>/var/log/bad.log</i> and filling up disk. You can check for example with <kbd>tail -f /var/log/bad.log</kbd>.<br>
This program is no longer needed. Find it and terminate it. Do not delete the log file.

## Test

The log file size doesn't change (within a time interval bigger than the rate of change of the log file).<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

check.sh
```
#!/usr/bin/bash

log_file="/var/log/bad.log"

if [ -f "$log_file" ]; then
    current_size=$(stat -c %s "$log_file")
    sleep 0.5
    new_size=$(stat -c %s "$log_file")

    if [ "$current_size" -eq "$new_size" ]; then
        echo -n "OK"
    else
        echo -n "NO"
    fi
else
    echo -n "NO"
fi
```
