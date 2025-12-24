#!/bin/bash
#===============================================================================
# SOLUTION: Question 1 - Container Image Build & Export
#===============================================================================

# Step 1: Navigate to the Dockerfile directory
cd /tmp/ckad-q1

# Step 2: Build the container image
# Using Podman (preferred):
podman build -t demacu:3.0 -f Dockerfile .

# OR using Docker:
# docker build -t demacu:3.0 -f Dockerfile .

# Step 3: Export in OCI format
# Using Podman:
podman save --format oci-archive -o /tmp/ckad-output/demacu.tar demacu:3.0

# OR using Docker (note: Docker uses different format flag):
# docker save -o /tmp/ckad-output/demacu.tar demacu:3.0
# Note: Docker save creates Docker format by default, not OCI

# Verify the image exists
podman images | grep demacu

# Verify the export file
ls -la /tmp/ckad-output/demacu.tar

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. podman build -t <name>:<tag> -f <Dockerfile> <context>
# 2. podman save --format oci-archive -o <output.tar> <image>
# 3. Without --format flag, podman defaults to docker format
# 4. OCI format is required in the question
# 5. Don't push to any registry - just local save
# 6. Replace paths with actual exam paths
#===============================================================================
