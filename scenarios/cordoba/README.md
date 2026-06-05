# "Cordoba": df is lying (or is it du?)

## Description

Monitoring reports that the root filesystem is under pressure, but a quick <kbd>du</kbd> of <i>/var/log</i> shows almost nothing in the logs of the running application at <i>/var/log/cordoba-app</i>.
<br><br>
Find what is holding the space and reclaim it so <kbd>df</kbd> and <kbd>du</kbd> agree again for practical purposes; currently there's a ~300 MB discrepancy on the root partition /
<br><br>
The service unit is <i>cordoba-hoarder.service</i>.

## Test

<kbd>df -h /</kbd> and <kbd>sudo du -sh /</kbd> report the same used space after reclaiming the ~300 MB discrepancy.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Baseline written at image build (KiB used on / with the 400 MiB ghost leak active).
BASELINE_FILE=/var/lib/cordoba-baseline-kb
# Require at least this many KiB reclaimed vs baseline (leak is 400 MiB).
MIN_RECLAIM_KB=307200

baseline=$(tr -d ' \n\r' <"$BASELINE_FILE" 2>/dev/null)
used=$(df -k / | awk 'NR==2 {print $3}')

if [ -z "$baseline" ] || [ -z "$used" ]; then
  echo -n "NO"
  exit 0
fi

reclaimed=$((baseline - used))
if [ "$reclaimed" -lt "$MIN_RECLAIM_KB" ]; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
