#!/bin/bash
# Question 4: Scale Deployment & Create NodePort Service - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Deployment has 4 replicas
echo -n "1. Checking deployment has 4 replicas... "
REPLICAS=$(kubectl get deployment november-2025-deployment -n november-2025 -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$REPLICAS" = "4" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Deployment has $REPLICAS replicas, expected 4\n"
    PASS=false
fi

# Check 2: Pod template has tier=frontend label
echo -n "2. Checking pod template has 'tier=frontend' label... "
TIER_LABEL=$(kubectl get deployment november-2025-deployment -n november-2025 -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null)
if [ "$TIER_LABEL" = "frontend" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod template missing 'tier=frontend' label (got: '$TIER_LABEL')\n"
    PASS=false
fi

# Check 3: Service 'berry' exists
echo -n "3. Checking service 'berry' exists... "
if kubectl get svc berry -n november-2025 &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Service 'berry' not found in namespace 'november-2025'\n"
    PASS=false
fi

# Check 4: Service is NodePort type
echo -n "4. Checking service is NodePort type... "
SVC_TYPE=$(kubectl get svc berry -n november-2025 -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$SVC_TYPE" = "NodePort" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Service type is '$SVC_TYPE', expected 'NodePort'\n"
    PASS=false
fi

# Check 5: Service port is 8080
echo -n "5. Checking service port is 8080... "
SVC_PORT=$(kubectl get svc berry -n november-2025 -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$SVC_PORT" = "8080" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Service port is '$SVC_PORT', expected '8080'\n"
    PASS=false
fi

# Check 6: Target port is 80
echo -n "6. Checking target port is 80... "
TARGET_PORT=$(kubectl get svc berry -n november-2025 -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$TARGET_PORT" = "80" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Target port is '$TARGET_PORT', expected '80'\n"
    PASS=false
fi

# Check 7: Service selector matches tier=frontend
echo -n "7. Checking service selector has 'tier=frontend'... "
SELECTOR=$(kubectl get svc berry -n november-2025 -o jsonpath='{.spec.selector.tier}' 2>/dev/null)
if [ "$SELECTOR" = "frontend" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Service selector missing 'tier=frontend'\n"
    PASS=false
fi

# Check 8: 4 pods running
echo -n "8. Checking 4 pods are running... "
RUNNING_PODS=$(kubectl get pods -n november-2025 -l tier=frontend --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l)
if [ "$RUNNING_PODS" -eq 4 ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - $RUNNING_PODS pods running with tier=frontend, expected 4\n"
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
