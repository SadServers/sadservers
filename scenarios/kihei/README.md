# "Kihei": Surely Not Another Disk Space Scenario

## Description

There is a <i>/home/admin/kihei</i> program. Make the changes necessary so it runs succesfully, without deleting the <i>/home/admin/datafile</i> file.

switch to root with su - (instead of su)

## Test

Running <kbd>/home/admin/kihei</kbd> returns <kbd>Done.</kbd>.

<b>check.sh</b>

```
#!/usr/bin/bash
# 6GB datafile exists
res=$(ls -l /home/admin/datafile |cut -d' ' -f 5)
res=$(echo $res|tr -d '\r')

if [[ "$res" != "5368709120" ]]
then
  echo -n "NO"
  exit
fi

# kihei binary didn't change
res=$(md5sum /home/admin/kihei |cut -d' ' -f 1)
res=$(echo $res|tr -d '\r')

if [[ "$res" != "79387f23f56e732aa789ee22761f8b84" ]]
then
  echo -n "NO"
  exit
fi

# kihei runs succesfully
res=$(/home/admin/kihei)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "Done." ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
