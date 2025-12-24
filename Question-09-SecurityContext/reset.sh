#!/bin/bash
echo "🧹 Cleaning up Question 9..."
kubectl delete deployment secure-app -n codel --ignore-not-found=true
kubectl delete namespace codel --ignore-not-found=true
echo "✅ Cleanup complete!"
