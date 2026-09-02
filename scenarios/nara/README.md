# "Nara": No ls on this system

## Description

Common directory-listing tools on this host are missing or refuse to run. A document named <kbd>shosoin.tag</kbd> was misplaced somewhere under <i>/home/admin/records</i>.
<br><br>
Write its full <b>absolute path</b> (one line) to <i>/home/admin/solution.txt</i>, for example:
<kbd>echo "/home/admin/records/some/dir/shosoin.tag" > /home/admin/solution.txt</kbd>
<br><br>
NOTE: There are at least 9 different ways to find the solution in this server (shown in the clues).

## Test

<kbd>md5sum /home/admin/solution.txt</kbd> returns <kbd>8d3b739ebccb41c7c39e608d7a3e0bd6</kbd> (the solution without the trailing newline is also accepted).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

f=/home/admin/solution.txt
if [ ! -f "$f" ]; then
  echo -n "NO"
  exit 0
fi

got=$(md5sum "$f" | awk '{print $1}')
if [ "$got" = "8d3b739ebccb41c7c39e608d7a3e0bd6" ] || [ "$got" = "652f92b6b17d1a55034eb79451eaa35f" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
