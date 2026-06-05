# "Poznań": Helm Chart Issue in Kubernetes

## Description

NOTE: Prompt may take a few extra seconds to be responsive while the k3s environment gets ready. Root access is not needed for this challenge ("admin" user cannot sudo).
<br><br>
A DevOps engineer created a Helm Chart web_chart with a custom nginx site, however he still gets the default nginx <i>index.html</i>.<br><br>
You can check for example with
<kbd>POD_IP=$(kubectl get pods -n default -o jsonpath='{.items[0].status.podIP}')</kbd> and 
<kbd>curl -s "${POD_IP}"></kbd>.<br><br>
In addition he should set replicas to 3.<br><br>
The chart is not working as expected. Fix the configurations so you get the custom HTML page from any nginx pod.
<br><br>
Credit <a href="https://www.devkblaz.com/" target="_blank">Kamil Błaż</a>

## Test

Doing `curl` on the default port (:80) of any nginx pod returns a `Welcome SadServers` page.  

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

helm get values web-chart | grep -q "replicaCount: 3"
GET_REPLICAS=$?
POD_IP=$(kubectl get pods -n default -o jsonpath='{.items[0].status.podIP}')
curl -s "${POD_IP}" | grep -q "Welcome SadServers"
CHECK_WEB_SERVER=$?

if [[ "${GET_REPLICAS}" -eq 0 ]] && [[ "${CHECK_WEB_SERVER}" -eq 0 ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
