#!/bin/bash
# Question 2: Secrets as Environment Variables - Reset

echo "🧹 Cleaning up Question 2..."
kubectl delete pod env-secret-pod --ignore-not-found=true
kubectl delete secret db-credentials --ignore-not-found=true
echo "✅ Cleanup complete!"
