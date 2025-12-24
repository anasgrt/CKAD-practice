#!/bin/bash
# Question 1: Container Image Build & Export
# Setup script - Creates the Dockerfile for the exercise

set -e

echo "🔧 Setting up Question 1 environment..."

# Create working directory
WORK_DIR="/tmp/ckad-q1"
mkdir -p "$WORK_DIR"
mkdir -p /tmp/ckad-output

# Create a sample Dockerfile
cat > "$WORK_DIR/Dockerfile" << 'EOF'
FROM docker.io/library/nginx:alpine
LABEL maintainer="ckad-practice"
RUN echo "<h1>CKAD Practice - Container Build Test</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

echo "✅ Dockerfile created at: $WORK_DIR/Dockerfile"
echo "✅ Output directory ready at: /tmp/ckad-output/"
echo ""
echo "📁 Working Directory: $WORK_DIR"
echo ""

# Check available container tools
echo "🔍 Available container tools:"
if command -v podman &> /dev/null; then
    echo "   ✅ podman: $(podman --version 2>/dev/null | head -1)"
fi
if command -v docker &> /dev/null; then
    echo "   ✅ docker: $(docker --version 2>/dev/null | head -1)"
fi
if command -v buildah &> /dev/null; then
    echo "   ✅ buildah: $(buildah --version 2>/dev/null | head -1)"
fi

echo ""
echo "🎯 Environment ready!"
