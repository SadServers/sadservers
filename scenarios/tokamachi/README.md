# "Tokamachi": Troubleshooting a Named Pipe

## Description

There's a process reading from the named pipe _/home/admin/namedpipe_.  

If you run this command that writes to that pipe:  

`
/bin/bash -c 'while true; do echo "this is a test message being sent to the pipe" > /home/admin/namedpipe; done' &
`  

And check the reader log with `tail -f reader.log`  

You'll see that after a minute or so it works for a while (the reader receives some messages) and then it stops working (no more received messages are printed to the reader log or it takes a long time to process one). Troubleshoot and fix (for example changing the writer command) so that the writer keeps sending the messages and the reader is able to read all of them. 


## Test

There should be a process running where a message is being sent to the pipe and that while that is running, another message can be sent to the pipe and read back.

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if ! ps auxf|grep -q 'pipe" > /home/admin/named[pipe]'; then
  echo -n "NO"
  exit
fi

uui=$(uuidgen| cut -c1-8)
echo $uui > /home/admin/namedpipe
sleep 1

if grep -q "$uui" /home/admin/reader.log; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
