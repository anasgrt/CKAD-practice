#!/bin/bash
# Question 4: Scale Deployment & Create NodePort Service - Setup

set -e
echo "🔧 Setting up Question 4 environment..."

kubectl create namespace november-2025 --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete deployment november-2025-deployment -n november-2025 --ignore-not-found=true 2>/dev/null || true
kubectl delete svc berry -n november-2025 --ignore-not-found=true 2>/dev/null || true
sleep 2

# Create initial deployment with 2 replicas (needs to be scaled to 4)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: november-2025-deployment
  namespace: november-2025
spec:
  replicas: 2
  selector:
    matchLabels:
      app: november-app
  template:
    metadata:
      labels:
        app: november-app
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

echo "✅ Namespace 'november-2025' created"
echo "✅ Deployment 'november-2025-deployment' created (2 replicas)"
echo ""
echo "📍 Current state:"
kubectl get deployment -n november-2025
echo ""
echo "🎯 Environment ready!"
