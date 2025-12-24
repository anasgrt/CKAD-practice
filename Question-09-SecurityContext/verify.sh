#!/bin/bash
# Question 9: Security Context - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Deployment exists
echo -n "1. Checking deployment 'secure-app' exists... "
if kubectl get deployment secure-app -n codel &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Deployment 'secure-app' not found in namespace 'codel'\n"
    PASS=false
fi

# Check 2: Pod-level runAsUser is 30000
echo -n "2. Checking pod-level runAsUser=30000... "
RUN_AS_USER=$(kubectl get deployment secure-app -n codel -o jsonpath='{.spec.template.spec.securityContext.runAsUser}' 2>/dev/null)
if [ "$RUN_AS_USER" = "30000" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod runAsUser is '$RUN_AS_USER', expected '30000'\n"
    PASS=false
fi

# Check 3: Container-level allowPrivilegeEscalation is false
echo -n "3. Checking container-level allowPrivilegeEscalation=false... "
ALLOW_PRIV=$(kubectl get deployment secure-app -n codel -o jsonpath='{.spec.template.spec.containers[0].securityContext.allowPrivilegeEscalation}' 2>/dev/null)
if [ "$ALLOW_PRIV" = "false" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - allowPrivilegeEscalation is '$ALLOW_PRIV', expected 'false'\n"
    PASS=false
fi

# Check 4: Deployment is available
echo -n "4. Checking deployment is available... "
AVAILABLE=$(kubectl get deployment secure-app -n codel -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ "$AVAILABLE" -ge 1 ] 2>/dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Deployment not available (may be crashlooping due to security settings)\n"
    PASS=false
fi

# Check 5: Verify actual pod has correct security context
echo -n "5. Verifying running pod security context... "
POD=$(kubectl get pods -n codel -l app=secure-app -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "$POD" ]; then
    POD_USER=$(kubectl get pod "$POD" -n codel -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null)
    if [ "$POD_USER" = "30000" ]; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - Running pod runAsUser is '$POD_USER', expected '30000'\n"
        PASS=false
    fi
else
    echo "⚠️  SKIP (no running pod found)"
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
