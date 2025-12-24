#!/bin/bash
echo "🧹 Cleaning up Question 6..."
kubectl delete cronjob log-cleaner -n production --ignore-not-found=true
kubectl delete job -l app=log-cleaner -n production --ignore-not-found=true 2>/dev/null || true
kubectl delete job manual-test -n production --ignore-not-found=true 2>/dev/null || true
kubectl delete namespace production --ignore-not-found=true
echo "✅ Cleanup complete!"
