# "Tarifa": Between Two Seas

## Description

There are three Docker containers defined in the <i>docker-compose.yml</i> file: an HAProxy accepting connetions on port :5000 of the host, and two nginx containers, not exposed to the host.<br><br>
The person who tried to set this up wanted to have HAProxy in front of the (backend or upstream) nginx containers load-balancing them but something is not working.

## Test

Running <kbd>curl localhost:5000</kbd> several times returns both <kbd>hello there from nginx_0</kbd> and <kbd>hello there from nginx_1</kbd><br><br>
Check <i>/home/admin/agent/check.sh</i> for the test that "Check My Solution" runs.  


<b>check.sh</b>

```
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

found=0

for i in {1..4}
do
  res=$(curl -s localhost:5000)
  ex=$?
  if test "$ex" != "0"; then
     echo -n "NO"
     exit
  fi

  res2=$(echo $res|grep -s nginx_0)
  ex=$?
  if test "$ex" != "0"; then
     continue
  else
    found=1
    break
  fi
done

if test "$found" != "1"; then
   echo -n "NO"
   exit
fi

for i in {1..4}
do
  res=$(curl -s localhost:5000)
  ex=$?
  if test "$ex" != "0"; then
     echo -n "NO"
     exit
  fi

  res2=$(echo $res|grep -s nginx_1)
  ex=$?
  if test "$ex" != "0"; then
     continue
  else
    echo -n "OK"
    exit
  fi
done

echo -n "NO"
```
