#!/bin/bash
#===============================================================================
# SOLUTION: Question 4 - Scale Deployment & Create NodePort Service
#===============================================================================

# Step 1: Edit deployment to add label and scale
kubectl edit deployment november-2025-deployment -n november-2025
# OR use patch:
kubectl patch deployment november-2025-deployment -n november-2025 --type='json' -p='[
  {"op": "add", "path": "/spec/template/metadata/labels/key", "value": "value"},
  {"op": "replace", "path": "/spec/replicas", "value": 4}
]'

# Alternative: Scale separately
kubectl scale deployment november-2025-deployment -n november-2025 --replicas=4

# Step 2: Create NodePort service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: berry
  namespace: november-2025
spec:
  type: NodePort
  selector:
    key: value
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
EOF

# Step 3: Verify
kubectl get deployment -n november-2025
kubectl get pods -n november-2025 -l key=value
kubectl get svc berry -n november-2025

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. Labels go under spec.template.metadata.labels (pod template), NOT deployment metadata
# 2. Service selector must match pod labels exactly
# 3. port = service port (what clients connect to)
# 4. targetPort = container port (where traffic goes)
# 5. NodePort is auto-assigned if not specified (30000-32767)
#===============================================================================
