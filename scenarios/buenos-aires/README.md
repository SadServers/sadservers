# "Buenos Aires": Kubernetes Pod Crashing

## Description

There are two pods: "logger" and "logshipper" living in the default namespace. Unfortunately, logshipper has an issue (crashlooping) and is forbidden to see what logger is trying to say. Could you help fix Logshipper?
<br><br>
Do not change the K8S definition of the logshipper pod. <b>Use "sudo"</b>.
<br><br>Because k8s takes a minute or two to change the pod state initially, the check for the scenario is made to fail in the first two minutes.
<br><br>Credit <a href="https://www.linkedin.com/in/srivatsav-kondragunta/">Srivatsav Kondragunta</a>

## Test

<kbd>kubectl get pods -l app=logshipper --no-headers -o json | jq -r '.items[] | "\(.status.containerStatuses[0].ready)"'</kbd>  returns <kbd>true</kbd>


<b>check.sh</b>

```
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(uptime | cut -d' ' -f4)
if [[ "$res" == "0" || "$res" == "1" || "$res" == "2" ]]
then
  echo -n "NO"
  exit
fi

res=$(sudo kubectl get pods -l app=logshipper --no-headers -o json | jq -r '.items[] | "\(.status.containerStatuses[0].ready)"')
res=$(echo $res|tr -d '\r')

if [[ "$res" != "true" ]]
then
  echo -n "NO"
  exit
fi


res=$(sudo k3s kubectl get pods -l app=logshipper --no-headers -o custom-columns=":.spec.serviceAccountName")
res=$(echo $res|tr -d '\r')

if [[ "$res" = "logshipper-sa" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
