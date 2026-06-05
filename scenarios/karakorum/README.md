# "Karakorum": WTFIT – What The Fun Is This?

## Description

There's a binary at <kbd>/home/admin/wtfit</kbd> that nobody knows how it works or what it does (<i>"what the fun is this"</i>). Someone remembers something about <i>wtfit</i> needing to communicate to a service in order to start. Run this <i>wtfit</i> program so it doesn't exit with an error, fixing or working around things that you need but are broken in this server. (Note that you can open more than one web "terminal").

## Test

<kbd>/home/admin/wtfit</kbd> returns <kbd>OK.</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(cd /home/admin && ./wtfit)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "OK." ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
