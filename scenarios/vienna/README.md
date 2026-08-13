# "Vienna": The Vanishing Process

## Description

Our monitoring agent <kbd>monagent</kbd> keeps "crashing" — or at least that's what it looks like. Every few minutes it seems to disappear, but:
<br><br>
- <kbd>systemctl status monagent</kbd> always reports it as <i>active (running)</i><br>
- <kbd>journalctl -u monagent</kbd> shows no errors, panics, or OOM kills<br>
- CPU and memory usage are completely normal<br>
- Restarting the service "fixes" it, but only for a few minutes
<br><br>
Find out what is actually happening and correct /usr/local/bin/monagent-watchdog.sh so it tracks the running process correctly, without disabling the watchdog.</b>.

## Test

The watchdog unit is still active and, after a monagent restart, it does not kill/restart the newly started worker due to stale PID tracking.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

set -uo pipefail

# 1. Check if monagent.service is active
if ! systemctl is-active --quiet monagent.service 2>/dev/null; then
    echo -n "NO"
    exit 0
fi

# 2. Check if monagent-watchdog.path is active
if ! systemctl is-active --quiet monagent-watchdog.path 2>/dev/null; then
    echo -n "NO"
    exit 0
fi

# 3. Simulate service restart (as systemd watchdog would do)
sudo systemctl restart monagent.service >/dev/null 2>&1 || true

# Wait briefly for service to be active and obtain new PID
for i in {1..10}; do
    if systemctl is-active --quiet monagent.service 2>/dev/null; then
        break
    fi
    sleep 0.1
done

PID_AFTER_RESTART=$(systemctl show monagent.service -p MainPID --value 2>/dev/null || true)

if [[ -z "$PID_AFTER_RESTART" || "$PID_AFTER_RESTART" == "0" ]]; then
    echo -n "NO"
    exit 0
fi

# 4. Run the watchdog script
sudo /usr/local/bin/monagent-watchdog.sh >/dev/null 2>&1 || true

PID_AFTER_WATCHDOG=$(systemctl show monagent.service -p MainPID --value 2>/dev/null || true)

# If PID changed after watchdog execution, watchdog killed the process
if [[ "$PID_AFTER_RESTART" != "$PID_AFTER_WATCHDOG" ]]; then
    echo -n "NO"
    exit 0
fi

echo -n "OK"
exit 0
```
