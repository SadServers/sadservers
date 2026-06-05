# "Belo-Horizonte": A Java Enigma

## Description

(Credit for the idea: <i>fuero</i>)<br><br>

There is a one-class Java application in your /home/admin directory. Running the program will print out a secret code, or you may be able to extract the secret from the class file without executing it but I'm not providing any special tools for that.<br><br>
Put the secret code in a /home/admin/solution file, eg <kbd>echo "code" >  /home/admin/solution</kbd>.

## Test

<kbd>md5sum /home/admin/solution |awk '{print $1}'</kbd> returns <kbd>9d2bd7aabb26681eacd9444da6b6643c</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(md5sum /home/admin/solution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "9d2bd7aabb26681eacd9444da6b6643c" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
