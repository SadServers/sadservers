# Scenario 14 "Oaxaca": Close an Open File

## Description

The file <i>/home/admin/somefile</i> is open for writing by some process. Close this file without killing the process.

## Test

<kbd>lsof /home/admin/somefile</kbd> returns nothing.

check.sh
```
#!/usr/bin/bash
res=$(lsof /home/admin/somefile)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
