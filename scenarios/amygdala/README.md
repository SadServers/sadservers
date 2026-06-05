# "Amygdala": Do you have enough insight to see the secrets?

## Description

Troubleshoot and fix a Kubernetes web application running in the <i>app</i> namespace. Make the deployment run successfully so that it returns <i>Hello handsome!</i> when you curl it.
<br><br>
Fix first your <i>admin</i> user access to the local Kubernetes cluster; the <i>KUBECONFIG</i> environment variable <b>must be set</b> to <i>$HOME/.kube/config</i>.
<br><br>
You have full admin access to a Vault server (containing the secrets you need) from the <i>admin</i> user. All the used manifests for the application are placed on the <i>/home/admin/manifests</i> directory.

## Test

Running: <kbd>POD_IP=$(kubectl get po -n app -l app=app -o jsonpath='{.items[0].status.podIP}') curl http://$POD_IP</kbd> returns <kbd>Hello handsome!</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

export KUBECONFIG="$HOME/.kube/config"

fail() {
  echo -n "NO"
  exit
}

if [ ! -f "$HOME/.kube/config" ]; then
  fail
fi

for es in env env-hidden; do
  OUT=$(kubectl get externalsecret "$es" -n app -o jsonpath='{.status.conditions[0].type} {.status.conditions[0].status}')
  TYPE=$(awk '{print $1}' <<<"$OUT")
  STATUS=$(awk '{print $2}' <<<"$OUT")

  if [ "$TYPE" != "Ready" ] || [ "$STATUS" != "True" ]; then
    fail
  fi
done

if [ "$(kubectl get ns app -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}')" != "baseline" ]; then
  fail
fi

POD_IP=$(kubectl get po -n app -l app=app -o jsonpath='{.items[0].status.podIP}')
if [ "$(curl -s --max-time 1 http://"$POD_IP")" != "Hello handsome!" ]; then
  fail
fi

echo -n "OK"
```
