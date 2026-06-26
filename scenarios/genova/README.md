# "Genova": cgroups problem

## Description

This small VM runs <i>sad-api</i> (a lightweight health endpoint on port <kbd>9090</kbd>) and <i>sad-batch</i> (a nightly ETL-style job that allocates a lot of RAM).
<br><br>
After a recent deploy, starting <i>sad-batch</i> caused memory use to spike and <i>sad-api</i> was killed by the OOM killer. On-call stopped the batch service before handing you the host.
<br><br>
A legacy cgroup v2 launcher under <kbd>/opt/sad/</kbd> is supposed to enforce a <kbd>128M</kbd> hard limit on cgroup <kbd>sad-batch</kbd>, but the cap never applies.
<br><br>
<i>sad-batch</i> is intentionally <b>stopped and disabled</b> when you log in. Read <kbd>/home/admin/incident-notes.txt</kbd> for context. Fix the cgroup configuration so <kbd>/sys/fs/cgroup/sad-batch/memory.max</kbd> is <kbd>134217728</kbd> before you start the batch job again.
<br><br>
Do not change <i>sad-api</i>; it should keep running on <kbd>127.0.0.1:9090</kbd>.

## Test

<i>sad-api</i> is active and <kbd>curl http://127.0.0.1:9090/</kbd> returns <kbd>SadServers - API OK</kbd>.
<br><br>
The cgroup v2 hard limit is in place: <kbd>cat /sys/fs/cgroup/sad-batch/memory.max</kbd> prints <kbd>134217728</kbd> (128&nbsp;MiB).
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

systemctl is-active --quiet sad-api.service || fail

if ! curl -s -m 2 http://127.0.0.1:9090/ | grep -q 'SadServers - API OK'; then
  fail
fi

if [ ! -f /sys/fs/cgroup/sad-batch/memory.max ]; then
  fail
fi

max=$(tr -d '[:space:]' < /sys/fs/cgroup/sad-batch/memory.max 2>/dev/null)
if [ -z "$max" ] || [ "$max" = "max" ]; then
  fail
fi

if [ "$max" != "134217728" ]; then
  fail
fi

echo -n "OK"
```
