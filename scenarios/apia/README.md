# "Apia": Needle in a Haystack

## Description

In a directory <i>/home/admin/data</i>, there are multiple files, all of them with same content. One of these files has been modified, a word was added. You need to identify which word it is and put it in the solution file (both newline terminated or not are accepted).

## Test

The "Check My Solution" button runs the script `/home/admin/agent/check.sh`, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash
res=$(md5sum /home/admin/solution | awk '{print $1}')
res=$(echo $res | tr -d '\r')

if [[ "$res" = "55aba155290288b58e9b778c8f616560" || "$res" = "2eeefea9fc4b16ea624bed5c67a49d80" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
