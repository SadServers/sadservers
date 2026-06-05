# "Porto": Port audit without net tools

## Description

The security team removed common network recon utilities from this host. Your job is to determine which TCP ports on <b>localhost</b> (<kbd>127.0.0.1</kbd>) are accepting connections.
<br><br>
The ports to check are listed in <i>/home/admin/ports-to-scan.txt</i> (one port per line).
<br><br>
Write your results to <i>/home/admin/port-audit.txt</i> with <b>one line per port</b>, sorted by port number (ascending), using this format:
<br><br>
<pre>
PORT STATUS
</pre>
where <i>STATUS</i> is exactly <kbd>open</kbd> or <kbd>closed</kbd> (lowercase).
<br><br>
A template file <i>/home/admin/port-audit.txt</i> is available with values per port "open|closed", delete the separator and the incorrect value per port or re-create the file.
<br><br>
The following are <b>not available</b> on this system (removed or restricted): <kbd>ss</kbd>, <kbd>netstat</kbd>, <kbd>nmap</kbd>, <kbd>nc</kbd>, <kbd>telnet</kbd>, <kbd>curl</kbd>, <kbd>lsof</kbd>, <kbd>tcpdump</kbd>.
<br><br>
NOTE: you don't have root (superuser) access.

## Test

The file <i>/home/admin/port-audit.txt</i> exists and correctly reports whether each port in <i>/home/admin/ports-to-scan.txt</i> is <kbd>open</kbd> or <kbd>closed</kbd> on <kbd>127.0.0.1</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

AUDIT="/home/admin/port-audit.txt"

if [ ! -f "$AUDIT" ]; then
  echo -n "NO"
  exit 0
fi

res=$(md5sum "$AUDIT" | awk '{print $1}')
res=$(echo "$res" | tr -d '\r')

# Accepted port-audit.txt digests (with/without trailing newline, optional blank line at EOF)
case "$res" in
  1d1131fbe44fad31eb09e809c43e9289|\
  5acad5317da633b6c76f93dfd16e086b|\
  655ed2d1661331c29c30f716e6a5d3b7)
    echo -n "OK"
    ;;
  *)
    echo -n "NO"
    ;;
esac
```
