#!/bin/bash
#===============================================================================
# SOLUTION: Question 5 - Rolling Updates, maxSurge/maxUnavailable & Rollback
#===============================================================================

# Task 1: Edit maxSurge and maxUnavailable
kubectl edit deployment app -n nov-2025
# Find spec.strategy.rollingUpdate and change to:
#   maxSurge: 5%
#   maxUnavailable: 2%

# OR use patch:
kubectl patch deployment app -n nov-2025 --type='json' -p='[
  {"op": "replace", "path": "/spec/strategy/rollingUpdate/maxSurge", "value": "5%"},
  {"op": "replace", "path": "/spec/strategy/rollingUpdate/maxUnavailable", "value": "2%"}
]'

# Task 2: Rolling update 'web' to nginx:1.13
kubectl set image deployment/web nginx=nginx:1.13 -n nov-2025
kubectl rollout status deployment/web -n nov-2025

# Task 3: Rollback 'app' to previous version
kubectl rollout history deployment/app -n nov-2025  # Check history first
kubectl rollout undo deployment/app -n nov-2025
kubectl rollout status deployment/app -n nov-2025

# Verify
kubectl get deployments -n nov-2025 -o wide
kubectl rollout history deployment/app -n nov-2025

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. maxSurge: max pods ABOVE desired count during update
# 2. maxUnavailable: max pods that can be unavailable during update
# 3. kubectl set image deployment/<n> <container>=<image>
# 4. kubectl rollout undo reverts to previous revision
# 5. kubectl rollout undo --to-revision=N for specific revision
#===============================================================================
