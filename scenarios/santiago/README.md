# "Santiago": Find the secret combination

## Description

Alice the spy has hidden a secret number combination, find it using these instructions:<br><br>
1) Find the number of <b>lines</b> with occurrences of the string <b>Alice</b> (case sensitive) in the <i>*.txt</i> files in the <i>/home/admin</i> directory<br>
2) There's a file where <b>Alice</b> appears exactly once. In that file, in the line after that "Alice" occurrence there's a number.<br>
Write both numbers consecutively as one (no new line or spaces) to the solution file. For example if the first number from 1) is <i>11</i> and the second <i>22</i>, you can do <kbd>echo -n 11 > /home/admin/solution; echo 22 >> /home/admin/solution</kbd> or echo "1122" > /home/admin/solution.

## Test

Running <kbd>md5sum /home/admin/solution</kbd> returns <kbd>d80e026d18a57b56bddf1d99a8a491f9</kbd>(just a way to verify the solution without giving it away.)

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(md5sum /home/admin/solution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "d80e026d18a57b56bddf1d99a8a491f9" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
