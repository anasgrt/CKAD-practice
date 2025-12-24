#!/bin/bash
# Question 1: Container Image Build & Export
# Reset/cleanup script

echo "🧹 Cleaning up Question 1 environment..."

# Remove the image
if command -v podman &> /dev/null; then
    podman rmi ckad-app:1.0 2>/dev/null || true
fi
if command -v docker &> /dev/null; then
    docker rmi ckad-app:1.0 2>/dev/null || true
fi

# Remove output files
rm -f /tmp/ckad-output/ckad-app.tar

# Remove working directory
rm -rf /tmp/ckad-q1

echo "✅ Cleanup complete!"
