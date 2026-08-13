# "Tokamachi": Troubleshooting a Named Pipe

## Description

There's a process reading from the named pipe <i>/home/admin/namedpipe</i>.
<br><br>
If you run this command that writes to that pipe:
<br><br>
<kbd>
/bin/bash -c 'while true; do echo "this is a test message being sent to the pipe" > /home/admin/namedpipe; done' &
</kbd>
<br><br>
And check the reader log with <kbd>tail -f reader.log</kbd>
<br><br>
You'll see that after a minute or so it works for a while (the reader receives some messages) and then it stops working (no more received messages are printed to the reader log or it takes a long time to process one). Troubleshoot and fix (for example changing the writer command) so that the writer keeps sending the messages and the reader is able to read all of them.

## Test

There should be a writer process sending messages to the pipe with a delay between writes (so the reader can keep up), and <i>reader.log</i> should still be receiving messages.<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if ! pgrep -f 'start_reader[.]sh' > /dev/null 2>&1; then
  echo -n "NO"
  exit 0
fi

if [ ! -s /home/admin/reader.log ]; then
  echo -n "NO"
  exit 0
fi

last_mod=$(stat -c %Y /home/admin/reader.log 2>/dev/null || echo 0)
now=$(date +%s)
if (( now - last_mod > 15 )); then
  echo -n "NO"
  exit 0
fi

if ! ps auxww | grep 'named[p]ipe' | grep -q 'sleep'; then
  echo -n "NO"
  exit 0
fi

echo -n "OK"
exit 0
```
