#!/bin/bash
echo "🧹 Cleaning up Question 7..."
kubectl delete pod cache -n web --ignore-not-found=true
kubectl delete namespace web --ignore-not-found=true
echo "✅ Cleanup complete!"
