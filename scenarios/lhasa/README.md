# Scenario 30: "Lhasa": Easy Math

## Description

There's a file <i>/home/admin/scores.txt</i> with two columns (the first number is a line number and the second one is a test score for example).<br><br>
Find the average (more precisely; the arithmetic mean: sum of numbers divided by how many numbers are there) of the numbers in the second column (find the average score).<br><br>
Use exactly two digits to the right of the decimal point. i.e., <b>use exactly two "decimal digits" without any rounding</b>. E.g.: if average = 21.349 , the solution is 21.34. If average = 33.1 , the solution is 33.10.<br><br>
Save the solution in the <i>/home/admin/solution</i> file, for example: <kbd>echo "123.45" > ~/solution</kbd> 
<br><br>
Tip: There's bc, Python3, Golang and sqlite3 installed in this VM.

## Test

<kbd>md5sum /home/admin/solution</kbd> returns <kbd>6d4832eb963012f6d8a71a60fac77168  solution</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)
res=$(md5sum /home/admin/solution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "6d4832eb963012f6d8a71a60fac77168" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
