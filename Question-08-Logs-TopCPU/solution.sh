#!/bin/bash
#===============================================================================
# SOLUTION: Question 8 - Retrieve Logs & Find Highest CPU Pod
#===============================================================================

# Task A: Deploy pod and retrieve logs

# Step 1: Apply the pod manifest
kubectl apply -f /tmp/ckad-q8/winter-pod.yaml

# Step 2: Wait for pod to be ready and generate logs
kubectl wait --for=condition=Ready pod/winter-pod --timeout=60s
sleep 5  # Wait for logs to be generated

# Step 3: Retrieve logs and save to file
kubectl logs winter-pod > /opt/ckad/logs-output.txt

# Verify
cat /opt/ckad/logs-output.txt

# Task B: Find highest CPU pod

# Step 1: View pod metrics
kubectl top pod -n cpu-stress

# Step 2: Get highest CPU pod and save name to file
kubectl top pod -n cpu-stress --no-headers | sort -k2 -nr | head -n1 | awk '{print $1}' > /opt/ckad/pod.txt

# Verify
cat /opt/ckad/pod.txt

#===============================================================================
# COMMAND BREAKDOWN:
#===============================================================================
# kubectl top pod -n cpu-stress    # Get pod metrics
# --no-headers                      # Remove header row from output
# sort -k2 -nr                      # Sort by column 2 (CPU), numeric, reverse
# head -n1                          # Get first line (highest CPU)
# awk '{print $1}'                  # Extract only the pod name (column 1)
# > /opt/ckad/pod.txt               # Write to file
#===============================================================================

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. kubectl logs <pod> > file.txt redirects logs to file
# 2. kubectl top requires metrics-server to be running
# 3. Linux pipe commands (sort, awk, head) are essential for CKAD
# 4. --no-headers prevents header row from being included in sort
# 5. Always verify output files after creating them
#===============================================================================
