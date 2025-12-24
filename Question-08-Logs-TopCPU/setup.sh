#!/bin/bash
# Question 8: Logs & Resource Monitoring - Setup

set -e
echo "🔧 Setting up Question 8 environment..."

kubectl create namespace cpu-stress --dry-run=client -o yaml | kubectl apply -f -

# Clean up
kubectl delete pod winter-pod --ignore-not-found=true 2>/dev/null || true
kubectl delete pod -n cpu-stress --all --ignore-not-found=true 2>/dev/null || true
rm -f /opt/ckad/logs-output.txt /opt/ckad/pod.txt 2>/dev/null || true

# Create output directory
mkdir -p /opt/ckad

# Create winter-pod manifest
mkdir -p /tmp/ckad-q8
cat <<EOF > /tmp/ckad-q8/winter-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: winter-pod
spec:
  containers:
  - name: logger
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - |
      echo "Winter Pod Started"
      echo "Timestamp: \$(date)"
      echo "Hostname: \$(hostname)"
      echo "Processing data..."
      for i in 1 2 3 4 5; do
        echo "Log entry \$i: Task completed successfully"
        sleep 1
      done
      echo "All tasks finished"
      sleep 3600
EOF

# Create CPU stress pods with different resource usage
for i in 1 2 3; do
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: stress-pod-$i
  namespace: cpu-stress
spec:
  containers:
  - name: stress
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - |
      # Simulate different CPU loads
      count=0
      while true; do
        for j in \$(seq 1 $((i * 1000))); do
          echo \$j > /dev/null
        done
        count=\$((count + 1))
        if [ \$count -ge 100 ]; then
          sleep 1
          count=0
        fi
      done
    resources:
      requests:
        cpu: "$((i * 50))m"
        memory: "32Mi"
      limits:
        cpu: "$((i * 100))m"
        memory: "64Mi"
EOF
done

echo ""
echo "✅ Namespace 'cpu-stress' created with stress pods"
echo "✅ Pod manifest ready at: /tmp/ckad-q8/winter-pod.yaml"
echo "✅ Output directory ready at: /opt/ckad/"
echo ""
echo "📍 Files to create:"
echo "   - /opt/ckad/logs-output.txt"
echo "   - /opt/ckad/pod.txt"
echo ""

# Wait for pods
echo "⏳ Waiting for stress pods to start..."
sleep 5

echo ""
echo "📍 Current stress pods:"
kubectl get pods -n cpu-stress
echo ""
echo "🎯 Environment ready!"
echo ""
echo "⚠️  Note: 'kubectl top' requires metrics-server. If not installed,"
echo "   the verification will check your command syntax instead."
