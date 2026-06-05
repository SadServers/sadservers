# "Tigoni": Patch and Pray!

## Description

A developer wants to upgrade their stateful application. This application handles their archives/backups. 
<br><br>
The application <i>tigoni</i> is deployed on kubernetes in the <i>default</i> namespace.
<br>
The application server is deployed by Helm. The command they used is <i>helm install tigoni charts/tigoni</i>.
<br><br>
Upgrade the tigoni application to <i>v2.0.0</i>. The image already exists in the local repository.
<br>
Debug and help the developer fix any issue with the upgrade.
<br>
Everytime v1.0.0 is launched the archiving code starts on a clean slate.

## Test

The <i>tigoni</i> pod with version v2 runs correctly (its endpoint :3000/healthz displays <i>serverVersion:v2</i>)<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

kubectl port-forward pod/tigoni-0 3333:3333 > /dev/null 2>&1 &

sleep 2 #allow the server port forward to be setup

result=$(curl -s localhost:3333/healthz 2> /dev/null)
if [ "$result" = "{\"serverVersion\":\"v2\"}" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
