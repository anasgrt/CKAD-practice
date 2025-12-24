#!/bin/bash
#===============================================================================
# SOLUTION: Question 9 - Security Context - runAsUser & Privilege Escalation
#===============================================================================

# Method 1: Edit deployment directly
kubectl edit deployment secure-app -n codel

# Add under spec.template.spec:
#   securityContext:
#     runAsUser: 30000
#
# Add under spec.template.spec.containers[0]:
#   securityContext:
#     allowPrivilegeEscalation: false

# Method 2: Use patch
kubectl patch deployment secure-app -n codel --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/securityContext",
    "value": {"runAsUser": 30000}
  },
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/securityContext",
    "value": {"allowPrivilegeEscalation": false}
  }
]'

# Method 3: Apply complete manifest
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: codel
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      securityContext:           # POD-level security context
        runAsUser: 30000
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        securityContext:         # CONTAINER-level security context
          allowPrivilegeEscalation: false
EOF

# Verify
kubectl rollout status deployment/secure-app -n codel
kubectl describe deployment secure-app -n codel | grep -A10 "Pod Template"

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. runAsUser: POD-level (spec.template.spec.securityContext)
#    - All containers run as this user
#
# 2. allowPrivilegeEscalation: CONTAINER-level (containers[].securityContext)
#    - Prevents container from gaining more privileges than parent
#
# 3. Common security context fields:
#    POD level: runAsUser, runAsGroup, fsGroup, runAsNonRoot
#    CONTAINER level: allowPrivilegeEscalation, readOnlyRootFilesystem,
#                     capabilities, privileged
#
# 4. K8s docs: search "Configure a Security Context for a Pod or Container"
#===============================================================================
