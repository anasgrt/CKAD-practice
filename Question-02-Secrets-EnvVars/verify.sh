#!/bin/bash
# Question 2: Secrets as Environment Variables
# Verification script

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Secret exists
echo -n "1. Checking if secret 'db-credentials' exists... "
if kubectl get secret db-credentials &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Secret 'db-credentials' not found\n"
    PASS=false
fi

# Check 2: Secret has correct keys
echo -n "2. Checking secret has 'username' and 'password' keys... "
if kubectl get secret db-credentials -o jsonpath='{.data}' 2>/dev/null | grep -q "username" && \
   kubectl get secret db-credentials -o jsonpath='{.data}' 2>/dev/null | grep -q "password"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Secret missing required keys (username, password)\n"
    PASS=false
fi

# Check 3: Secret values are correct
echo -n "3. Checking secret values are correct... "
USERNAME=$(kubectl get secret db-credentials -o jsonpath='{.data.username}' 2>/dev/null | base64 -d 2>/dev/null)
PASSWORD=$(kubectl get secret db-credentials -o jsonpath='{.data.password}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$USERNAME" = "admin" ] && [ "$PASSWORD" = "testpassword" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Secret values incorrect (expected username=admin, password=testpassword)\n"
    PASS=false
fi

# Check 4: Pod exists
echo -n "4. Checking if pod 'env-secret-pod' exists... "
if kubectl get pod env-secret-pod &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod 'env-secret-pod' not found\n"
    PASS=false
fi

# Check 5: Pod is running
echo -n "5. Checking if pod is running... "
POD_STATUS=$(kubectl get pod env-secret-pod -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$POD_STATUS" = "Running" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod status is '$POD_STATUS', expected 'Running'\n"
    PASS=false
fi

# Check 6: Pod uses busybox image
echo -n "6. Checking pod uses busybox image... "
IMAGE=$(kubectl get pod env-secret-pod -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [[ "$IMAGE" == *"busybox"* ]]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Pod image is '$IMAGE', expected 'busybox'\n"
    PASS=false
fi

# Check 7: Environment variables are set correctly
echo -n "7. Checking DB_USERNAME env var... "
DB_USER=$(kubectl exec env-secret-pod -- env 2>/dev/null | grep "^DB_USERNAME=" | cut -d= -f2)
if [ "$DB_USER" = "admin" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - DB_USERNAME='$DB_USER', expected 'admin'\n"
    PASS=false
fi

echo -n "8. Checking DB_PASSWORD env var... "
DB_PASS=$(kubectl exec env-secret-pod -- env 2>/dev/null | grep "^DB_PASSWORD=" | cut -d= -f2)
if [ "$DB_PASS" = "testpassword" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - DB_PASSWORD='$DB_PASS', expected 'testpassword'\n"
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
