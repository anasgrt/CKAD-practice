#!/bin/bash
# Question 5: Rolling Updates & Rollback - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: maxSurge is 5%
echo -n "1. Checking 'app' deployment maxSurge=5%... "
MAX_SURGE=$(kubectl get deployment app -n nov-2025 -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}' 2>/dev/null)
if [ "$MAX_SURGE" = "5%" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - maxSurge is '$MAX_SURGE', expected '5%'\n"
    PASS=false
fi

# Check 2: maxUnavailable is 2%
echo -n "2. Checking 'app' deployment maxUnavailable=2%... "
MAX_UNAVAIL=$(kubectl get deployment app -n nov-2025 -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}' 2>/dev/null)
if [ "$MAX_UNAVAIL" = "2%" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - maxUnavailable is '$MAX_UNAVAIL', expected '2%'\n"
    PASS=false
fi

# Check 3: 'web' deployment image is nginx:1.13
echo -n "3. Checking 'web' deployment image is nginx:1.13... "
WEB_IMAGE=$(kubectl get deployment web -n nov-2025 -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$WEB_IMAGE" = "nginx:1.13" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - 'web' image is '$WEB_IMAGE', expected 'nginx:1.13'\n"
    PASS=false
fi

# Check 4: 'app' deployment was rolled back (should be nginx:1.14)
echo -n "4. Checking 'app' deployment was rolled back to previous version... "
APP_IMAGE=$(kubectl get deployment app -n nov-2025 -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$APP_IMAGE" = "nginx:1.14" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - 'app' image is '$APP_IMAGE', expected 'nginx:1.14' (rollback)\n"
    PASS=false
fi

# Check 5: Deployments are ready
echo -n "5. Checking all deployments are ready... "
APP_READY=$(kubectl get deployment app -n nov-2025 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
WEB_READY=$(kubectl get deployment web -n nov-2025 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ "$APP_READY" -ge 1 ] && [ "$WEB_READY" -ge 1 ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Deployments not fully ready\n"
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
