# "Aswan": K8s Service Connectivity Failure

## Description

Our microservices application on Kubernetes cannot reach the <i>backend-db</i> service from the frontend deployment; <kbd>curl</kbd> from the frontend pod fails.
<br><br>
Your task is to diagnose and fix the connectivity problems so the frontend can reach the backend database. There may be more than one issue.
<br><br>
NOTE: wait for all the pods to be running at the beginning of the exercise.

## Test 

Curl from inside the frontend pod to the backend-db service returns "Hello from Backend DB!": <kbd>FRONTEND_POD=$(kubectl get pods -l app=frontend -o jsonpath='{.items[0].metadata.name}')</kbd><br>
<kbd>kubectl exec $FRONTEND_POD -- curl -s backend-db</kbd> returns <kbd>"Hello from Backend DB!"</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

FRONTEND_POD=$(kubectl get pods -l app=frontend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$FRONTEND_POD" ]; then
  echo -n "NO"
  exit 0
fi

RESULT=$(kubectl exec "$FRONTEND_POD" -- sh -c 'curl -s -m 1.5 backend-db 2>/dev/null' 2>/dev/null) || true

case "$RESULT" in
  *"Hello from Backend DB!"*) echo -n "OK" ;;
  *) echo -n "NO" ;;
esac
```
