# "Monaco": Disappearing Trick

## Description

There is a web server on :5000 with a form. POSTing the correct form password into this web service will return a secret.
<br><br>
Save this secret provided by the web page (not the password you sent to it)  to /home/admin/mysolution, for example: <kbd>echo "SecretFromWebSite" > ~/mysolution</kbd>
<br><br>
TIP: a developer worked on the web server code in this VM, using the same 'admin' account.
<br><br>
Scenario credit: PuppiestDoggo

## Test

<kbd>md5sum /home/admin/mysolution</kbd> returns <kbd>a250aa19f16dda6f9fcef286f035ec4b</kbd>

<b>check.sh</b>

```
#!/bin/bash

expected_checksum="a250aa19f16dda6f9fcef286f035ec4b"
actual_checksum=$(md5sum /home/admin/mysolution | awk '{print $1}')

if [[ "$actual_checksum" == "$expected_checksum" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
