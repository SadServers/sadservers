# "Bournemouth": Same job, three shells

## Description

This box is a small shell lab. Debian's <kbd>/bin/sh</kbd> is <b>dash</b>, your login shell is <b>bash</b>, and <b>zsh</b> is installed. Cron, Docker <kbd>CMD</kbd> lines, and most <kbd>#!/bin/sh</kbd> scripts do not run bash — and <kbd>zsh script.sh</kbd> does not honour a POSIX shebang.
<br><br>
Read <i>/home/admin/lab/00-START-HERE.txt</i> and run the demos with:
<br>
<kbd>/home/admin/lab/compare.sh /home/admin/lab/demos/01-identity.sh</kbd>
<br>
(there are ten snippets under <i>demos/</i>; <i>run-all.sh</i> runs every one).
<br><br>
Then write a script <i>/home/admin/fleet-report.sh</i> that prints a host status table from <i>/home/admin/lab/inventory/</i> (<i>hosts</i>, <i>disk.tsv</i>, <i>access.log</i>).
<br><br>
Rules:
<br>
- One header line exactly: <kbd>HOST DISK ERR STATUS</kbd><br>
- Then one line per host from <i>hosts</i>, in that file's order: <kbd>NAME DISK ERR STATUS</kbd> (single spaces, no tabs)<br>
- <i>DISK</i> is the integer from <i>disk.tsv</i><br>
- <i>ERR</i> is how many <i>access.log</i> lines have that host and code <kbd>500</kbd><br>
- <i>STATUS</i> is <kbd>crit</kbd> if DISK &gt;= 90 or ERR &gt;= 5; else <kbd>warn</kbd> if DISK &gt;= 80 or ERR &gt;= 1; else <kbd>ok</kbd>
<br><br>
The same file must print that table with <b>no extra lines</b> when run as:
<kbd>sh /home/admin/fleet-report.sh</kbd>,
<kbd>bash /home/admin/fleet-report.sh</kbd>, and
<kbd>zsh /home/admin/fleet-report.sh</kbd>.
<br><br>
<i>demos/10-broken-report.sh</i> is a bash sketch that is not a valid solution.

## Test

<i>/home/admin/fleet-report.sh</i> exists. <kbd>sh</kbd>, <kbd>bash</kbd>, and <kbd>zsh</kbd> each print the same report for the inventory files, matching the rules above.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() { echo -n "NO"; exit 0; }

script=/home/admin/fleet-report.sh
inv=/home/admin/lab/inventory
[ -f "$script" ] || fail
[ -r "$inv/hosts" ] && [ -r "$inv/disk.tsv" ] && [ -r "$inv/access.log" ] || fail
command -v zsh >/dev/null 2>&1 || fail

grep -q 'disk' "$script" || fail
grep -q 'access.log' "$script" || fail

exp=$(mktemp)
got=$(mktemp)
trap 'rm -f "$exp" "$got"' EXIT

{
  printf '%s\n' 'HOST DISK ERR STATUS'
  while IFS= read -r host || [ -n "$host" ]; do
    [ -z "$host" ] && continue
    disk=$(awk -v h="$host" '$1 == h { print $2; exit }' "$inv/disk.tsv")
    err=$(awk -v h="$host" '$1 == h && $2 == 500 { c++ } END { print c + 0 }' "$inv/access.log")
    [ -n "$disk" ] || fail
    if [ "$disk" -ge 90 ] || [ "$err" -ge 5 ]; then
      st=crit
    elif [ "$disk" -ge 80 ] || [ "$err" -ge 1 ]; then
      st=warn
    else
      st=ok
    fi
    printf '%s %s %s %s\n' "$host" "$disk" "$err" "$st"
  done < "$inv/hosts"
} > "$exp"

for interp in sh bash zsh; do
  "$interp" "$script" > "$got" 2>/dev/null || fail
  cmp -s "$exp" "$got" || fail
done

echo -n "OK"
exit 0
```
