# "Tukaani": XZ LZMA Library Compromised

## Description

This is a scenario where a Linux shared library liblzma.so has been compromised (the real compromised XZ Utils liblzma has not been used). Find all instances of this malicious liblzma library and make it so none of the running processes use it and all the applications ("webapp", "jobapp")  still run properly (eg, stopping those applications is not a solution).

This liblzma.so at the path `/usr/lib/x86_64-linux-gnu/liblzma.so.5.2.5` is the good one. Consider the same library liblzma.so.5.2.5 at other paths as compromised (ideally we would have used other real versions with different checksums but we were not able to).

The "webapp" responds to `curl http://127.0.0.1:8000` and the docker version of it "user-service" responds to `curl http://127.0.0.1:8001` with "Hello, We are using lzma library to compress our requests."

Find all the "compromised" libraries paths that are used by the hijacked processes. Save their paths in the /home/admin/paths file (one path per line), for example: `echo '/path/to/liblzma.so.5' >> /home/admin/paths`, one per path.



## Test

`lsof | grep liblzma.so.5` returns only the liblzma in the path: `/usr/lib/x86_64-linux-gnu/liblzma.so.5.2.5`

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# check that the 'webapp' is running
res=$(curl -s http://127.0.0.1:8000|grep -c lzma)
CHECK_WEB_SERVER=$?
if [[ "${CHECK_WEB_SERVER}" -ne 0 ]]; then
    echo -n "NO"
    exit
fi

# check that the jobapp is running
res=$(systemctl is-active jobapp)
if [[ "${res}" != "active" ]]; then
    echo -n "NO"
    exit
fi

# only liblzma from /usr/lib/x86_64-linux-gnu/ is allowed
sudo lsof | grep liblzma.so.5 | awk '{ if ($NF != "/usr/lib/x86_64-linux-gnu/liblzma.so.5.2.5") { printf "NO"; found=1; exit } } END { if (!found) { printf "OK" } }'
```
