# CKAD 2025 Exam Questions & Answers - JayDemy Series

Complete practice environment for 9 CKAD exam questions extracted from JayDemy's YouTube series.

**Source:** JayDemy YouTube Channel  
**Playlist:** CKAD Exam Series  
**Total Questions:** 9

## Prerequisites

- Access to a Kubernetes cluster (k3s, kind, minikube, or any dev cluster)
- `kubectl` configured and working
- `podman` or `docker` for Question 1 (container image)
- Metrics server for Question 8 (optional, verification will adapt)

## Quick Start

```bash
cd ckad-practice

# List all available questions
./scripts/run-question.sh list

# Start a question (sets up environment + shows question)
./scripts/run-question.sh Question-01-Container-Image

# Verify your answer
./scripts/run-question.sh Question-01-Container-Image verify

# View solution if stuck
./scripts/run-question.sh Question-01-Container-Image solution

# Reset/cleanup
./scripts/run-question.sh Question-01-Container-Image reset
```

## Questions Overview

| # | Question | Domain | Weight |
|---|----------|--------|--------|
| 1 | Container Image Build & Export (OCI) | Application Design and Build | ~4% |
| 2 | Secrets as Environment Variables | Configuration and Security | ~7% |
| 3 | RBAC - Role & RoleBinding | Configuration and Security | ~8% |
| 4 | Scale Deployment & NodePort Service | Application Deployment | ~7% |
| 5 | Rolling Updates & Rollback | Application Deployment | ~10% |
| 6 | CronJob with Completions | Application Design and Build | ~7% |
| 7 | Redis Pod with Exposed Port | Application Design and Build | ~4% |
| 8 | Logs & Top CPU Pod | Observability and Maintenance | ~5% |
| 9 | Security Context | Configuration and Security | ~7% |

## Workflow

1. **Setup**: `./scripts/run-question.sh Question-XX` - Creates resources and shows question
2. **Solve**: Use kubectl to complete the task
3. **Verify**: `./scripts/run-question.sh Question-XX verify` - Check your answer
4. **Solution**: `./scripts/run-question.sh Question-XX solution` - View solution if stuck
5. **Reset**: `./scripts/run-question.sh Question-XX reset` - Clean up before next attempt

## Directory Structure

```
ckad-practice/
├── scripts/
│   └── run-question.sh      # Main runner script
├── Question-01-Container-Image/
│   ├── setup.sh             # Environment setup
│   ├── question.txt         # Question text
│   ├── verify.sh            # Answer verification
│   ├── solution.sh          # Solution with explanations
│   └── reset.sh             # Cleanup script
├── Question-02-Secrets-EnvVars/
│   └── ...
└── README.md
```

## Exam Tips

1. **Always switch context first** before answering any question
2. **Use imperative commands** when possible to save time
3. **Use K8s documentation** - know search keywords
4. **Verify your work** - always check pods are running
5. **Practice Linux commands** - sort, awk, grep, head are essential

## Commands Cheat Sheet

```bash
# Context
kubectl config use-context <context>

# Create resources
kubectl create secret generic <n> --from-literal=key=value
kubectl create ns <namespace>
kubectl run <pod> --image=<image> --port=<port>

# Edit & Update
kubectl edit deployment <n> -n <ns>
kubectl set image deployment/<n> <container>=<image>
kubectl scale deployment <n> --replicas=N

# Rollouts
kubectl rollout status deployment/<n>
kubectl rollout history deployment/<n>
kubectl rollout undo deployment/<n>

# Debug
kubectl logs <pod> -n <ns>
kubectl exec -it <pod> -- /bin/sh
kubectl describe pod <pod> -n <ns>
kubectl top pod -n <ns>

# RBAC
kubectl auth can-i <verb> <resource> --as=system:serviceaccount:<ns>:<sa>
```

## Source

Questions extracted from JayDemy YouTube CKAD Exam Series:
https://www.youtube.com/playlist?list=PLSsEvm2nF_8npYf8cvoLsCsf6ki_togh0
