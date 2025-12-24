#!/bin/bash
# Question 6: CronJob Configuration - Setup

set -e
echo "🔧 Setting up Question 6 environment..."

kubectl create namespace production --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete cronjob log-cleaner -n production --ignore-not-found=true 2>/dev/null || true
kubectl delete job -l app=log-cleaner -n production --ignore-not-found=true 2>/dev/null || true

echo "✅ Namespace 'production' created"
echo ""
echo "📍 Namespace: production"
echo ""
echo "🎯 Environment ready!"
