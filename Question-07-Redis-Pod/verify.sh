#!/bin/bash
# Question 7: Redis Pod - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Pod exists
echo -n "1. Checking pod 'cache' exists in namespace 'web'... "
if kubectl get pod cache -n web &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod 'cache' not found in namespace 'web'\n"
    PASS=false
fi

# Check 2: Pod is running
echo -n "2. Checking pod is running... "
STATUS=$(kubectl get pod cache -n web -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$STATUS" = "Running" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod status is '$STATUS', expected 'Running'\n"
    PASS=false
fi

# Check 3: Image is redis:3.2
echo -n "3. Checking image is redis:3.2... "
IMAGE=$(kubectl get pod cache -n web -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$IMAGE" = "redis:3.2" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Image is '$IMAGE', expected 'redis:3.2'\n"
    PASS=false
fi

# Check 4: Container port 6379 is exposed
echo -n "4. Checking containerPort 6379 is exposed... "
PORT=$(kubectl get pod cache -n web -o jsonpath='{.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [ "$PORT" = "6379" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - ContainerPort is '$PORT', expected '6379'\n"
    PASS=false
fi

# Check 5: Label app=cache exists
echo -n "5. Checking label 'app=cache' exists... "
LABEL=$(kubectl get pod cache -n web -o jsonpath='{.metadata.labels.app}' 2>/dev/null)
if [ "$LABEL" = "cache" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Label 'app' is '$LABEL', expected 'cache'\n"
    PASS=false
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
