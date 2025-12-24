#!/bin/bash
#===============================================================================
# SOLUTION: Question 3 - RBAC - Role & RoleBinding for Deployments
#===============================================================================

# Step 1: Verify the current issue
kubectl auth can-i list deployments --as=system:serviceaccount:meta:default -n meta
# Output: no

# Step 2: Create the Role
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: deployment-reader
  namespace: meta
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch"]
EOF

# Step 3: Create the RoleBinding
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: deployment-reader-binding
  namespace: meta
subjects:
- kind: ServiceAccount
  name: default
  namespace: meta
roleRef:
  kind: Role
  name: deployment-reader
  apiGroup: rbac.authorization.k8s.io
EOF

# Step 4: Verify the fix
kubectl auth can-i list deployments --as=system:serviceaccount:meta:default -n meta
# Output: yes

# Step 5: Restart the pod to pick up new permissions
kubectl delete pod -l app=dev-app -n meta

# Step 6: Check logs after restart
sleep 5
kubectl logs -l app=dev-app -n meta --tail=10

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. Deployments use apiGroups: ["apps"], NOT empty string (core API)
# 2. Core API (empty string) is for: pods, services, configmaps, secrets
# 3. Subject kind is "ServiceAccount", not "User"
# 4. roleRef.name must match the Role name exactly
# 5. Use kubectl auth can-i to verify permissions
#===============================================================================
