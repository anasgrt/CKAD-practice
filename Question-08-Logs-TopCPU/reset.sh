#!/bin/bash
echo "🧹 Cleaning up Question 8..."
kubectl delete pod winter-pod --ignore-not-found=true
kubectl delete namespace cpu-stress --ignore-not-found=true
rm -rf /tmp/ckad-q8 /opt/ckad/logs-output.txt /opt/ckad/pod.txt 2>/dev/null || true
echo "✅ Cleanup complete!"
