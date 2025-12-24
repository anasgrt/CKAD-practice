#!/bin/bash
echo "🧹 Cleaning up Question 4..."
kubectl delete svc berry -n november-2025 --ignore-not-found=true
kubectl delete deployment november-2025-deployment -n november-2025 --ignore-not-found=true
kubectl delete namespace november-2025 --ignore-not-found=true
echo "✅ Cleanup complete!"
