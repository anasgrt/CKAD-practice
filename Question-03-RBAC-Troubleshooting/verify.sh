#!/bin/bash
# Question 3: RBAC Troubleshooting - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Role exists
echo -n "1. Checking if Role 'deployment-reader' exists in namespace 'meta'... "
if kubectl get role deployment-reader -n meta &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Role 'deployment-reader' not found in namespace 'meta'\n"
    PASS=false
fi

# Check 2: Role has correct permissions
echo -n "2. Checking Role has correct permissions (deployments: get,list,watch)... "
RULES=$(kubectl get role deployment-reader -n meta -o jsonpath='{.rules}' 2>/dev/null)
if echo "$RULES" | grep -q "deployments" && echo "$RULES" | grep -q "list"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Role doesn't have correct permissions for deployments\n"
    PASS=false
fi

# Check 3: Role uses correct API group
echo -n "3. Checking Role uses 'apps' API group... "
APIGROUP=$(kubectl get role deployment-reader -n meta -o jsonpath='{.rules[*].apiGroups}' 2>/dev/null)
if echo "$APIGROUP" | grep -q "apps"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Role should use apiGroups: ['apps'] for deployments\n"
    PASS=false
fi

# Check 4: RoleBinding exists
echo -n "4. Checking if RoleBinding 'deployment-reader-binding' exists... "
if kubectl get rolebinding deployment-reader-binding -n meta &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - RoleBinding 'deployment-reader-binding' not found\n"
    PASS=false
fi

# Check 5: RoleBinding references correct Role
echo -n "5. Checking RoleBinding references Role 'deployment-reader'... "
ROLE_REF=$(kubectl get rolebinding deployment-reader-binding -n meta -o jsonpath='{.roleRef.name}' 2>/dev/null)
if [ "$ROLE_REF" = "deployment-reader" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - RoleBinding references '$ROLE_REF', expected 'deployment-reader'\n"
    PASS=false
fi

# Check 6: RoleBinding binds to default SA
echo -n "6. Checking RoleBinding binds to ServiceAccount 'default'... "
SUBJECT=$(kubectl get rolebinding deployment-reader-binding -n meta -o jsonpath='{.subjects[0].name}' 2>/dev/null)
if [ "$SUBJECT" = "default" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - RoleBinding subject is '$SUBJECT', expected 'default'\n"
    PASS=false
fi

# Check 7: Verify permissions work
echo -n "7. Verifying default SA can now list deployments... "
if kubectl auth can-i list deployments --as=system:serviceaccount:meta:default -n meta 2>/dev/null | grep -q "yes"; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - ServiceAccount 'default' still cannot list deployments\n"
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
