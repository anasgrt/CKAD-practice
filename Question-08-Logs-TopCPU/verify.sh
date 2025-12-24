#!/bin/bash
# Question 8: Logs & Resource Monitoring - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Pod winter-pod exists
echo -n "1. Checking pod 'winter-pod' was created... "
if kubectl get pod winter-pod &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod 'winter-pod' not found. Did you apply the manifest?\n"
    PASS=false
fi

# Check 2: Logs file exists
echo -n "2. Checking /opt/ckad/logs-output.txt exists... "
if [ -f "/opt/ckad/logs-output.txt" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - File /opt/ckad/logs-output.txt not found\n"
    PASS=false
fi

# Check 3: Logs file has content
echo -n "3. Checking logs file has content... "
if [ -f "/opt/ckad/logs-output.txt" ] && [ -s "/opt/ckad/logs-output.txt" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Logs file is empty\n"
    PASS=false
fi

# Check 4: Logs contain expected content
echo -n "4. Checking logs contain expected entries... "
if grep -q "Winter Pod Started" /opt/ckad/logs-output.txt 2>/dev/null && \
   grep -q "Log entry" /opt/ckad/logs-output.txt 2>/dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Logs don't contain expected content from winter-pod\n"
    PASS=false
fi

# Check 5: pod.txt file exists
echo -n "5. Checking /opt/ckad/pod.txt exists... "
if [ -f "/opt/ckad/pod.txt" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - File /opt/ckad/pod.txt not found\n"
    PASS=false
fi

# Check 6: pod.txt contains valid pod name
echo -n "6. Checking pod.txt contains a valid pod name... "
if [ -f "/opt/ckad/pod.txt" ]; then
    POD_NAME=$(cat /opt/ckad/pod.txt | tr -d '[:space:]')
    if kubectl get pod "$POD_NAME" -n cpu-stress &> /dev/null; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - '$POD_NAME' is not a valid pod in namespace cpu-stress\n"
        PASS=false
    fi
else
    echo "❌ SKIP"
    PASS=false
fi

# Check 7: Verify it's the highest CPU pod (if metrics available)
echo -n "7. Checking if correct pod identified (highest CPU)... "
if kubectl top pod -n cpu-stress &> /dev/null; then
    # Metrics server available
    HIGHEST=$(kubectl top pod -n cpu-stress --no-headers 2>/dev/null | sort -k2 -nr | head -1 | awk '{print $1}')
    USER_POD=$(cat /opt/ckad/pod.txt 2>/dev/null | tr -d '[:space:]')
    if [ "$HIGHEST" = "$USER_POD" ]; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - You identified '$USER_POD', but highest CPU pod is '$HIGHEST'\n"
        PASS=false
    fi
else
    # Metrics server not available - check if stress-pod-3 (highest requests)
    USER_POD=$(cat /opt/ckad/pod.txt 2>/dev/null | tr -d '[:space:]')
    if [ "$USER_POD" = "stress-pod-3" ]; then
        echo "✅ PASS (metrics-server unavailable, accepted stress-pod-3)"
    else
        echo "⚠️  SKIP (metrics-server not available)"
    fi
fi

echo ""

if [ "$PASS" = true ]; then
    echo "📊 Result: All checks passed!"
    exit 0
else
    echo "📊 Result: Some checks failed"
    echo ""
    echo "Errors:"
    echo -e "$ERRORS"
    exit 1
fi
