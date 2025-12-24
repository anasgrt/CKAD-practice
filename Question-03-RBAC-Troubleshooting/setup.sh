#!/bin/bash
# Question 3: RBAC Troubleshooting
# Setup script - Creates a broken deployment that needs RBAC fix

set -e

echo "🔧 Setting up Question 3 environment..."

# Check cluster access
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster."
    exit 1
fi

# Create namespace
kubectl create namespace meta --dry-run=client -o yaml | kubectl apply -f -

# Clean up any existing resources
kubectl delete deployment dev-deployment -n meta --ignore-not-found=true 2>/dev/null || true
kubectl delete role deployment-reader -n meta --ignore-not-found=true 2>/dev/null || true
kubectl delete rolebinding deployment-reader-binding -n meta --ignore-not-found=true 2>/dev/null || true
sleep 2

# Create a deployment that tries to list deployments (will fail without proper RBAC)
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dev-deployment
  namespace: meta
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dev-app
  template:
    metadata:
      labels:
        app: dev-app
    spec:
      containers:
      - name: kubectl-container
        image: bitnami/kubectl:latest
        command: 
        - /bin/sh
        - -c
        - |
          while true; do
            echo "Attempting to list deployments..."
            kubectl get deployments -n meta 2>&1 || echo "ERROR: Cannot list deployments"
            sleep 30
          done
EOF

echo "✅ Namespace 'meta' created"
echo "✅ Deployment 'dev-deployment' created (with RBAC issue)"
echo ""
echo "📍 Namespace: meta"
echo ""

# Wait for pod to start
echo "⏳ Waiting for pod to start..."
sleep 5

# Show the error
echo ""
echo "🔴 Current pod logs (showing the error):"
POD=$(kubectl get pods -n meta -l app=dev-app -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "$POD" ]; then
    kubectl logs "$POD" -n meta --tail=5 2>/dev/null || echo "Pod not ready yet"
fi

echo ""
echo "🎯 Environment ready!"
