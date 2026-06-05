# "Lyon": Migrate Ingress-NGINX to Traefik

## Description

Ingress-NGINX is being retired. As the DevOps Engineer, you will replace it with Traefik on the production Kubernetes cluster in a private VPC. This scenario is a local proof-of-concept for that migration.
<br><br>
The current K8s cluster has a "Hello World" pod running, i.e.: <kbd>curl hello.lyon.local</kbd> returns "Hello world" (see note 1). You should be able to see the same content delivered via Traefik once the ingress-nginx is down. 
<br><br>
<b>Notes:</b>
1: Wait at the start until k8s is fully up before doing curl, otherwise you get 503, you can check for ex with <kbd>k get pod -n ingress-nginx</kbd><br>
2: The k8s manifests are under the <i>~/app</i> dir.<br>
3: ingress-nginx was deployed with a Helm chart.<br>
4: The Helm chart for traefik is available under <i>/home/admin/traefik</i> (The Traefik image is already loaded in k3s).<br>
5: Traefik dashboard and probes/metrics port by default is :8080 but that's used by the system; use a different port or disable.<br>
6: The domain <i>hello.lyon.local</i> is actually pointing to the localhost.<br>
7: The ingress must be listening on port 80 for any IP so it can respond to <i>localhost:80</i> or actually to <i>*:80 </i>
<br><br>
<b>TIP:</b> You can use <kbd>k</kbd> as an alias for <kbd>kubectl</kbd>, and it has autocomplete enabled.

## Test

When the command <kbd>curl -i hello.lyon.local</kbd> is executed, it returns the message <i>Hello World</i>, while only the traefik pod must be present (instead of ingress-nginx).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res=$(curl -s -m 2 hello.lyon.local)
ing=$(kubectl get pod --all-namespaces | grep traefik | grep Running | wc -l)

if [ "$res" == "Hello World" ]; then
  if [ $ing -gt 1 ]; then
    echo -n "OK"
  else
    echo -n "NO"
  fi
else
  echo -n "NO"
fi
```
