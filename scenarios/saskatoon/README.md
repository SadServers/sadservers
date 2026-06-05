# "Saskatoon": counting IPs.

## Description

There's a web server access log file at <kbd>/home/admin/access.log</kbd>. The file consists of one line per HTTP request, with the requester's IP address at the beginning of each line (first column).
<br><br>Find what's the IP address that has the most requests in this file (there's no tie; the IP is unique). Write the solution into a file <kbd>/home/admin/highestip.txt</kbd>. For example, if your solution is "1.2.3.4", you can do <kbd>echo "1.2.3.4" > /home/admin/highestip.txt</kbd>
<br><br>
NOTE: The solution IP shows 482 times, ie <kbd>grep -c -F -f highestip.txt access.log</kbd> returns <kbd>482</kbd>, if your solution has a different (lower) number you got the wrong most common IP.

## Test

The SHA1 checksum of the IP address <kbd>sha1sum /home/admin/highestip.txt</kbd> is <kbd>6ef426c40652babc0d081d438b9f353709008e93</kbd> (just a way to verify the solution without giving it away.)

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(sha1sum /home/admin/highestip.txt |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "6ef426c40652babc0d081d438b9f353709008e93" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
