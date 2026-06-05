# "Roseau": Hack a Web Server

## Description

There is a secret stored in a file that the local Apache web server can provide. Find this secret and have it as a /home/admin/secret.txt file.<br><br>
Note that in this server the <i>admin</i> user is not a sudoer.<br><br>
Also note that the password crackers <i>Hashcat</i> and <i>Hydra</i> are installed from packages and <i>John the Ripper</i> binaries have been built from source in <i>/home/admin/john/run</i>

## Test

<kbd>sha1sum /home/admin/secret.txt |awk '{print $1}'</kbd> returns <kbd>cc2c322fbcac56923048d083b465901aac0fe8f8</kbd>


<b>check.sh</b>

```
#!/usr/bin/bash
res=$(sha1sum /home/admin/secret.txt |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "cc2c322fbcac56923048d083b465901aac0fe8f8" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
