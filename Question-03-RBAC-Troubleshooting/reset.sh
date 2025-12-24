#!/bin/bash
# Question 3: RBAC Troubleshooting - Reset

echo "🧹 Cleaning up Question 3..."
kubectl delete deployment dev-deployment -n meta --ignore-not-found=true
kubectl delete role deployment-reader -n meta --ignore-not-found=true
kubectl delete rolebinding deployment-reader-binding -n meta --ignore-not-found=true
kubectl delete namespace meta --ignore-not-found=true
echo "✅ Cleanup complete!"
