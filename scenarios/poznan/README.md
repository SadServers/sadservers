# "Poznań": Helm Chart Issue in Kubernetes

## Description

A DevOps engineer created a Helm Chart web_chart with a custom nginx site, however he still gets the default nginx _index.html_.  

You can check for example with
`POD_IP=$(kubectl get pods -n default -o jsonpath='{.items[0].status.podIP}')` and 
`curl -s "${POD_IP}">`.  

In addition he should set replicas to 3.  

The chart is not working as expected. Fix the configurations so you get the custom HTML page from any nginx pod.  

Root access is not needed ("admin" user cannot sudo).  

Credit [Kamil Błaż](https://www.devkblaz.com/)

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
