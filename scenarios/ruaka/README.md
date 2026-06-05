# "Ruaka": Kubernetes pod in distress

## Description

A developer wants to deploy an open-source tool on Kubernetes. The tool unfortunately has limited documentation.
<br><br>
They built a helm chart and a container image. When the application is deployed, for some reason the server in Kubernetes doesn't seem to work but when the binary is started on their laptop/machine it works perfectly.
<br><br>
The application server is deployed by Helm. The command they used is: <i>helm upgrade --install ruaka charts/ruaka</i>.
<br><br>
Debug and help the developer find the issue. <b>NOTE:</b> Do not delete any current Helm field in the chart.
<br><br>
Remember to give enough time to k8S after you apply a change before checking the solution.

## Test

<kbd>kubectl get pod</kbd> shows the ruaka application pod up and running, while no Helm fields have been taken out from the applicaiton chart.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

### Conditions for a successful fix.
1. Do not make changes to `cmd` of the container.
2. Add to the probes but don't update or remove fields.


**check.sh**

```bash
#!/bin/bash

no="NO"
ok="OK"

masterPatch='
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ruaka
  namespace: default
spec:
  template:
    spec:
      containers:
        - image: localhost:5000/ruaka:v0.0.3
          imagePullPolicy: IfNotPresent
          livenessProbe:
            failureThreshold: 3
            httpGet:
              path: /healthz
              port: http
              scheme: HTTP
            periodSeconds: 5
            successThreshold: 1
            terminationGracePeriodSeconds: 3
            timeoutSeconds: 1
          name: ruaka
          ports:
            - containerPort: 3333
              name: http
              protocol: TCP
          readinessProbe:
            httpGet:
              path: /
              port: http
              scheme: HTTP
            periodSeconds: 5
            successThreshold: 1
            timeoutSeconds: 1
            failureThreshold: 3

          resources:
            limits:
              cpu: 100m
              memory: 128Mi
            requests:
              cpu: 100m
              memory: 128Mi
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
  selector: {}
'
deployedPatch=$(kubectl get deploy -oyaml ruaka 2> /dev/null)
if [ $? -ne 0 ]; then
  # ruaka deployment file missing!
  echo -n "$no"
else
  masterFields='{name: .metadata.name, image: .spec.template.spec.containers[0].image, livenessProbePeriodSeconds: .spec.template.spec.containers[0].livenessProbe.periodSeconds, livenessProbeHttpGet: .spec.template.spec.containers[0].livenessProbe.httpGet, livenessProbeFailureThreshold: .spec.template.spec.containers[0].livenessProbe.failureThreshold, readinessProbePeriodSeconds: .spec.template.spec.containers[0].readinessProbe.periodSeconds, readinessProbeHttpGet: .spec.template.spec.containers[0].readinessProbe.httpGet, readinessProbeFailureThreshold: .spec.template.spec.containers[0].readinessProbe.failureThreshold}'

  if diff <(yq "$masterFields" <<<"$masterPatch") \
          <(yq "$masterFields" <<<"$deployedPatch") >/dev/null; then
    # sections are equal
    result=$(kubectl get deploy ruaka -o jsonpath='{.status.readyReplicas}/{.status.replicas}')
    ready=$(echo "$result" | cut -d/ -f1)
    total=$(echo "$result" | cut -d/ -f2)

    ready=${ready:-0}
    total=${total:-0}

    if [ "$ready" -eq "$total" ] && [ "$total" -gt 0 ]; then
       echo -n "$ok"
    else
        echo -n "$no"
    fi
  else
    # sections differ
    echo -n "$no"
  fi
fi
```
