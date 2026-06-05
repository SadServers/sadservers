# "Kilifi": Speculative Misallocation!

## Description

A developer is having trouble deploying an application on a preconfigured cluster. 
<br><br>
The application <i>kilifi</i> is to be deployed on kubernetes in the <i>default</i> namespace.
<br>
The application server is deployed by helm. The command they used is <i>helm install kilifi charts/kilifi</i>.
<br>
The application operates correctly with ~210 MB of memory, but 256 MB is recommended.
<br><br>
<i>Swap should remain disabled in the cluster.</i>
<br><br>
Debug and help the developer fix any issue with deployment.

## Test

The kilifi application runs properly; it's Service on :3333/healthz returns "kilifi ready to serve".
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

kubectl port-forward service/kilifi 3333:3333 > /dev/null 2>&1 &

sleep 2 #allow the server port forward to be setup

result=$(curl -s localhost:3333/healthz 2> /dev/null)
if [ "$result" = "kilifi ready to serve" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
