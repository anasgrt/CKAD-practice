#!/bin/bash
# Question 7: Create Pod with Redis and Expose Port - Setup

set -e
echo "🔧 Setting up Question 7 environment..."

kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete pod cache -n web --ignore-not-found=true 2>/dev/null || true
kubectl delete svc cache-service -n web --ignore-not-found=true 2>/dev/null || true

echo "✅ Namespace 'web' created"
echo ""
echo "📍 Namespace: web"
echo ""
echo "🎯 Environment ready!"
