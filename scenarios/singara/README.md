# "Singara": Docker and Kubernetes web app not working

## Description

There's a <i>k3s</i> Kubernetes install you can access with <i>kubectl</i>. The Kubernetes YAML manifests under <kbd>/home/admin</kbd> have been applied. The objective is to access from the host the "webapp" web server deployed and find what message it serves (it's a name of a town or city btw). In order to pass the check, the webapp Docker container should not be run separately outside Kubernetes as a shortcut.

## Test

<kbd>curl localhost:8888</kbd> returns a value from the webapp deployed Kubernetes pod.

<b>check.sh</b>

```
#!/usr/bin/bash
key=$(curl -s localhost:8888)
key=$(echo $key|tr -d '\r')
res=$(echo -n $key|md5sum|awk '{print $1}')
res=$(echo $res|tr -d '\r')
res2=$(sudo docker ps -a|grep 8888)

if [[ "$res" = "c6faeb6a2f39140cccf1f69cc3be84cd" && "$res2" = "" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
