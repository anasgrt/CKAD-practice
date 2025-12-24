#!/bin/bash
# Question 9: Security Context - Setup

set -e
echo "🔧 Setting up Question 9 environment..."

kubectl create namespace codel --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete deployment secure-app -n codel --ignore-not-found=true 2>/dev/null || true
sleep 2

# Create deployment WITHOUT security context (needs to be fixed)
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
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

# Wait for deployment
kubectl rollout status deployment/secure-app -n codel --timeout=60s

echo ""
echo "✅ Namespace 'codel' created"
echo "✅ Deployment 'secure-app' created (needs security context)"
echo ""
echo "📍 Current deployment status:"
kubectl get deployment -n codel
echo ""
echo "📍 Current security context (none configured):"
kubectl get deployment secure-app -n codel -o jsonpath='{.spec.template.spec.securityContext}' && echo " (empty)"
echo ""
echo "🎯 Environment ready!"
