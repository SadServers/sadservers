# "Paris": Where is my webserver?

## Description

A developer put an important password on his webserver localhost:5000 . However, he can't find a way to recover it. This scenario is easy to to once you realize the one "trick".
<br><br>
Find the password and save it in /home/admin/mysolution , for example: <kbd>echo "somepassword" > ~/mysolution</kbd>
<br><br>
Scenario credit: PuppiestDoggo

## Test

<kbd>md5sum ~/mysolution</kbd> returns <kbd>d8bee9d7f830d5fb59b89e1e120cce8e</kbd>


<b>check.sh</b>

```
#!/bin/bash

expected_checksum="d8bee9d7f830d5fb59b89e1e120cce8e"
actual_checksum=$(md5sum /home/admin/mysolution | awk '{print $1}')

if [[ "$actual_checksum" == "$expected_checksum" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
