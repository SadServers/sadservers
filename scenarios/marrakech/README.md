# "Marrakech": Word Histogram

## Description

Find in the file <i>frankestein.txt</i> the <strong>second</strong> most frequent word and save in <strong>UPPER</strong> (capital) case in the <i>/home/admin/mysolution</i> file.
<br><br>
A word is a string of characters separated by space or newlines or punctuation symbols <kbd>.,:;</kbd> . Disregard case ('The', 'the' and 'THE' is the same word) and for simplification consider the apostrophe as another character not as punctuation ("it's" would be a word, distinct from "it" and "is"). Also disregard plurals ("car" and "cars" are different words) and other word variations (don't do "stemming").
<br><br>
We are providing a shorter <i>test.txt</i> file where the second most common word in upper case is "WORLD", so we could save this solution as: <kbd>echo "WORLD" > /home/admin/mysolution</kbd>
<br><br>This problem can be done with a programming language (Python, Golang and sqlite3) or with common Linux utilities.

## Test

<kbd>echo "SOLUTION" | md5sum</kbd> returns <kbd>19bf32b8725ec794d434280902d78e18</kbd>
<br><br>
See <i>/home/admin/agent/check.sh</i> for the test that "Check My Solution" runs.

check.sh

```
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(md5sum /home/admin/mysolution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "19bf32b8725ec794d434280902d78e18" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
