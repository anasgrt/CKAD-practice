#!/bin/bash
# Question 2: Secrets as Environment Variables
# Setup script

set -e

echo "🔧 Setting up Question 2 environment..."

# Check kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please ensure you have access to a Kubernetes cluster."
    exit 1
fi

# Check cluster access
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster. Please check your kubeconfig."
    exit 1
fi

# Clean up any existing resources from previous attempts
kubectl delete secret db-credentials --ignore-not-found=true 2>/dev/null || true
kubectl delete pod env-secret-pod --ignore-not-found=true 2>/dev/null || true

# Wait for cleanup
sleep 2

echo "✅ Kubernetes cluster connected"
echo "✅ Default namespace cleaned up"
echo ""
echo "📍 Current context: $(kubectl config current-context)"
echo "📍 Namespace: default"
echo ""
echo "🎯 Environment ready!"
