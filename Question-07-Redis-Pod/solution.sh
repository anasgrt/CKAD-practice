#!/bin/bash
#===============================================================================
# SOLUTION: Question 7 - Create Pod with Redis and Expose Port
#===============================================================================

# Method 1: Imperative command
kubectl run cache --image=redis:3.2 --port=6379 -l app=cache -n web

# Method 2: Using manifest
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cache
  namespace: web
  labels:
    app: cache
spec:
  containers:
  - name: cache
    image: redis:3.2
    ports:
    - containerPort: 6379
EOF

# Verify
kubectl get pod cache -n web
kubectl describe pod cache -n web | grep -A5 "Containers:"

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. "Expose port" in pod = containerPort (NOT a Service)
# 2. Only create Service if question explicitly asks
# 3. kubectl run --port sets containerPort
# 4. Labels are set with -l flag or in metadata.labels
# 5. Redis default port is 6379
#===============================================================================
