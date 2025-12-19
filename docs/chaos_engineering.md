# Chaos Engineering & Failure Simulation

This document outlines the failure scenarios designed to test the self-healing and auto-scaling capabilities of the platform.

## Prerequisites
- Cluster is running.
- Prometheus/Grafana is installed.
- `kubectl` is configured.

---

## Scenario 1: Pod Crash (Self-Healing)
**Goal:** Verify Kubernetes automatically restarts a crashed application.

**Action:**
Kill the main process inside a backend pod.
```bash
# Get pod name
POD=$(kubectl get pods -l app=backend -o jsonpath="{.items[0].metadata.name}")

# Exec into pod and kill the process (simulating a crash)
# Note: Since we use minimal images, we might not have 'kill'. 
# We can simply delete the pod to simulate a crash or use a chaos tool.
kubectl delete pod $POD
```

**Observation:**
- Watch pods: `kubectl get pods -w`
- **Result:** The deployment controller notices the pod is missing and immediately starts a new one (Desired: 2, Current: 1 -> 2).
- **Grafana:** Check `Pod Restarts` metric to see the spike.

---

## Scenario 2: Node Failure (Resilience)
**Goal:** Verify the system recovers when an underlying EC2 node dies.

**Action:**
Terminate an EC2 instance manually in the AWS Console.

```bash
# Find the instance ID of a worker node
aws ec2 describe-instances --filters "Name=tag:eks:cluster-name,Values=prod-furever-cluster" --query "Reservations[*].Instances[*].InstanceId"

# Terminate it
aws ec2 terminate-instances --instance-ids <INSTANCE_ID>
```

**Observation:**
- **Kubernetes:** Pods on that node go to `Unknown` or `Terminating` state.
- **Scheduler:** Kubernetes reschedules those pods to the remaining healthy nodes.
- **AWS Auto Scaling:** The ASG detects the unhealthy instance and launches a new EC2 instance.
- **Recovery:** Once the new node joins, the cluster capacity returns to normal.

---

## Scenario 3: High CPU Load (Auto-Scaling)
**Goal:** Verify Horizontal Pod Autoscaler (HPA) scales up pods under load.

**Action:**
Generate load using a busy loop or a load testing tool.

```bash
# Run a temporary pod to generate load
kubectl run -i --tty load-generator --image=busybox /bin/sh

# Inside the pod, run a loop hitting the internal service
while true; do wget -q -O- http://backend; done
```

**Observation:**
- Watch HPA: `kubectl get hpa -w`
- **Result:** CPU usage rises above 50%.
- **Action:** HPA increases `REPLICAS` from 2 -> 3 -> ... -> 10.
- **Recovery:** Stop the load generator. HPA scales back down after a cooldown period (usually 5 mins).
