# "Bologna": counting ELB 5xx errors

## Description

Operations handed you a classic AWS Elastic Load Balancer access log at <kbd>/home/admin/elb.log</kbd>. Each line is one request. Fields are space-separated; the quoted HTTP request starts at field 12, so the numeric fields before it are fixed-width columns.
<br><br>
Field 8 is the ELB status code and field 9 is the <b>backend</b> status code returned by the target instance. Count how many log lines have a backend status code in the 5xx range (500 through 599). Write that integer — digits only — to <kbd>/home/admin/solution.txt</kbd>. For example: <kbd>echo 42 > ~/solution.txt</kbd>
<br><br>
The log mixes successful responses, redirects, client errors, and server errors; only backend 5xx responses count toward your answer.

## Test

The MD5 checksum of your answer file <kbd>md5sum /home/admin/solution.txt</kbd> is <kbd>b73ce398c39f506af761d2277d853a92</kbd> (we also accept the correct count with a trailing newline in the file).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/solution.txt | awk '{print $1}')
res=$(echo "$res" | tr -d '\r')

if [[ "$res" = "b73ce398c39f506af761d2277d853a92" || "$res" = "52154e9782f4ab05f7f77fc4abe6161d" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
