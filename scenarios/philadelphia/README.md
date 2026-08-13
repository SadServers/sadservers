# "Philadelphia": htop metrics disagree

## Description

This host exports load and uptime to <i>/var/lib/sad/sysinfo.txt</i> for a small internal dashboard. <i>htop</i> and <i>btop</i> are installed for troubleshooting.
<br><br>
On-call reports the dashboard shows <b>load stuck at 0.00</b> and an <b>old uptime</b>, while the live process viewers look correct. A leftover lab service leaves a <b>defunct (zombie)</b> child in the process list.
<br><br>
Read <kbd>/home/admin/incident-notes.txt</kbd>. Fix the exporter and the zombie lab so published metrics match the real kernel counters and no zombie children remain under the lab parent.

## Test

The 1st line of <i>/var/lib/sad/sysinfo.txt</i> is <kbd>SadServers - Philadelphia OK</kbd>. The <kbd>load_1m</kbd> and <kbd>uptime_seconds</kbd> values in that file match <i>/proc/loadavg</i> and <i>/proc/uptime</i> (within a small tolerance).
<br>
<i>sad-zombie-lab</i> is active and has no zombie children.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() {
  echo -n "NO"
  exit 0
}

if [ ! -f /var/lib/sad/sysinfo.txt ]; then
  fail
fi

if ! head -n 1 /var/lib/sad/sysinfo.txt | grep -q 'SadServers - Philadelphia OK'; then
  fail
fi

reported_load=$(grep '^load_1m=' /var/lib/sad/sysinfo.txt 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
actual_load=$(awk '{print $1}' /proc/loadavg 2>/dev/null | tr -d '[:space:]')
if [ -z "$reported_load" ] || [ -z "$actual_load" ]; then
  fail
fi
if ! awk -v r="$reported_load" -v a="$actual_load" 'BEGIN { exit !(r + 0 <= a + 0.20 && r + 0 >= a - 0.20) }'; then
  fail
fi

reported_uptime=$(grep '^uptime_seconds=' /var/lib/sad/sysinfo.txt 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
actual_uptime=$(awk '{print int($1)}' /proc/uptime 2>/dev/null)
if [ -z "$reported_uptime" ] || [ -z "$actual_uptime" ]; then
  fail
fi
uptime_diff=$((actual_uptime - reported_uptime))
if [ "$uptime_diff" -lt 0 ]; then
  uptime_diff=$((-uptime_diff))
fi
if [ "$uptime_diff" -gt 120 ]; then
  fail
fi

systemctl is-active --quiet sad-zombie-lab.service || fail

parent=$(pgrep -f '^/opt/sad/zombie-lab$' 2>/dev/null | head -n 1)
if [ -z "$parent" ]; then
  fail
fi

while read -r cpid; do
  [ -z "$cpid" ] && continue
  child_stat=$(ps -o stat= -p "$cpid" 2>/dev/null | tr -d '[:space:]')
  case "$child_stat" in
    Z*) fail ;;
  esac
done < <(pgrep -P "$parent" 2>/dev/null || true)

echo -n "OK"
```
