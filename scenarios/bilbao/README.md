# "Bilbao": Basic Kubernetes Problems

## Description

There's a Kubernetes Deployment with an Nginx pod and a Load Balancer declared in the <i>manifest.yml</i> file. The pod is not coming up. Fix it so that you can access the Nginx container through the Load Balancer.<br><br>
There's no "sudo" (root) access.
<br><br>
<b>TIP:</b> You can use <kbd>k</kbd> as an alias for <kbd>kubectl</kbd>, and it has autocomplete enabled.

## Test

Running <kbd>curl 10.43.216.196</kbd> returns the default Nginx Welcome page.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

phase=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].status.phase}' 2>/dev/null | tr -d '\r')
if [ "$phase" != "Running" ]; then
  echo -n "NO"
  exit 0
fi

ready=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].status.containerStatuses[0].ready}' 2>/dev/null | tr -d '\r')
if [ "$ready" != "true" ]; then
  echo -n "NO"
  exit 0
fi

body=$(curl -sf --max-time 2 http://10.43.216.196/ 2>/dev/null) || {
  echo -n "NO"
  exit 0
}

if printf '%s' "$body" | grep -qi 'Welcome to nginx'; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
