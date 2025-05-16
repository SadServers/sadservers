# "Bekasi": Supervisor your variables

## Description

There is an nginx service running on port 443, it is the main web server for the company and looks like a new employee has deployed some changes to the configuration of supervisor and now it is not working as expected.

if you try to access `curl -k https://bekasi` it should return `Hello SadServers!` but for reason it is not.

You cannot modify files from the `/home/admin/bekasi` folder in order to pass the check.sh

You must find out why and fix it.

## Test

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

bekasi_ini_hash=$(md5sum /home/admin/bekasi/bekasi.ini | awk '{print $1}')
bekasi_py_hash=$(md5sum /home/admin/bekasi/bekasi.py | awk '{print $1}')
wsgi_py_hash=$(md5sum /home/admin/bekasi/wsgi.py | awk '{print $1}')
http_res=$(curl -k https://bekasi 2> /dev/null)

# Compare the computed hashes with the expected values
if [ "$bekasi_ini_hash" == "305916e8aa6e5b4b8145510b5c1070f0" ] && \
   [ "$bekasi_py_hash"  == "fc577d5e09cb47215a20b3159279cf94" ] && \
   [ "$wsgi_py_hash"    == "1892690dae0b3b2e20792ea530ab8d16" ] && \
   [ "$http_res"        == "Hello SadServers!" ];
then
    echo -n "OK"
else
    echo -n "NO"
fi
```

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.
