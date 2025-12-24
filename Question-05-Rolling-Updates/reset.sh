#!/bin/bash
echo "🧹 Cleaning up Question 5..."
kubectl delete deployment app web -n nov-2025 --ignore-not-found=true
kubectl delete namespace nov-2025 --ignore-not-found=true
echo "✅ Cleanup complete!"
