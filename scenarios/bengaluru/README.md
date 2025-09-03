# "Bengaluru": Kubernetes StatefulSet least known characteristic

## Description

There's a Kubernetes cluster (created with "k3d") with two worker nodes and two pods on the node _k3d-cluster-agent-0_: a Deployment _demo-deployment-..._ and a StatefulSet _demo-statefulset-0_. Their manifests are identical except for the different kind of K8s resource.  

Make the node hosting the pods unavailable (it "goes down" or "crashes" without being deleted from k8s), for example with: `docker stop k3d-mycluster-agent-0`.  

After waiting for about a minute (_tolerationSeconds_ in the manifest is 30s, we shorten the K8S 5 minutes default so you don't have to wait so much, plus a grace period), both pods are marked as Terminating. While the Deployment pod is evicted and deployed onto the remaining available node _k3d-cluster-agent-1_, the StatefulSet _demo-statefulset-0_ is not (Why?).  

Make the StatefulSet pod _demo-statefulset-0_ run on the available node.  

Note: you can use `k` as a shortcut for `kubectl`.

## Test

Node _k3d-cluster-agent-0_ is NotReady. Both the Deployment and the StatefulSet are running on the node _k3d-cluster-agent-1_
The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Deployment pod on k3d-my-cluster-agent-1 and running
running_dep=$(kubectl get pods -l app=demo-dep -o jsonpath="{.items[*].metadata.name}" --field-selector=status.phase=Running,spec.nodeName=k3d-mycluster-agent-1)

# Deployment pod on k3d-my-cluster-agent-1 and running
running_sts=$(kubectl get pods -l app=demo-sts -o jsonpath="{.items[*].metadata.name}" --field-selector=status.phase=Running,spec.nodeName=k3d-mycluster-agent-1)

# Node k3d-my-cluster-agent-0 does not exist anymore
node_check=$(kubectl get node k3d-my-cluster-agent-0 --ignore-not-found)

if [[ -n "$running_sts" ]] && [[ -n "$running_dep" ]] && [[ -z "$node_check" ]]; then
    echo -n "OK"
else
    echo -n "NO"
fi
```
