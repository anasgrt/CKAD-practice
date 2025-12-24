#!/bin/bash
#===============================================================================
# SOLUTION: Question 2 - Secrets as Environment Variables
#===============================================================================

# Step 1: Create the secret
kubectl create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=testpassword

# Step 2: Create pod manifest
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: env-secret-pod
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sleep", "3600"]
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-credentials
          key: password
EOF

# Step 3: Wait for pod to be ready
kubectl wait --for=condition=Ready pod/env-secret-pod --timeout=60s

# Step 4: Verify
kubectl exec env-secret-pod -- env | grep DB_

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. kubectl create secret generic <name> --from-literal=key=value
# 2. Use secretKeyRef under env to reference secret keys
# 3. env name (DB_USERNAME) can be different from secret key (username)
# 4. K8s docs: search "Define container environment variables using Secret data"
#===============================================================================
