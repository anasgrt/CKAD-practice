#!/bin/bash
# Question 5: Rolling Updates & Rollback - Setup

set -e
echo "🔧 Setting up Question 5 environment..."

kubectl create namespace nov-2025 --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete deployment app web -n nov-2025 --ignore-not-found=true 2>/dev/null || true
sleep 2

# Create 'app' deployment (for maxSurge/maxUnavailable and rollback)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: nov-2025
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: nginx
        image: nginx:1.14
EOF

# Create 'web' deployment (for rolling update to 1.13)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: nov-2025
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.12
EOF

# Wait for deployments
kubectl rollout status deployment/app -n nov-2025 --timeout=60s
kubectl rollout status deployment/web -n nov-2025 --timeout=60s

# Create rollout history for 'app' deployment
kubectl set image deployment/app nginx=nginx:1.15 -n nov-2025
kubectl rollout status deployment/app -n nov-2025 --timeout=60s

echo ""
echo "✅ Namespace 'nov-2025' created"
echo "✅ Deployment 'app' created (nginx:1.15, with rollout history)"
echo "✅ Deployment 'web' created (nginx:1.12)"
echo ""
echo "📍 Current state:"
kubectl get deployments -n nov-2025
echo ""
echo "📍 Rollout history for 'app':"
kubectl rollout history deployment/app -n nov-2025
echo ""
echo "🎯 Environment ready!"
