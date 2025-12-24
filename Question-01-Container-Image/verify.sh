#!/bin/bash
# Question 1: Container Image Build & Export
# Verification script

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: Image exists
echo -n "1. Checking if image 'demacu:3.0' exists... "
if command -v podman &> /dev/null; then
    if podman images | grep -q "demacu.*3.0"; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - Image 'demacu:3.0' not found in podman\n"
        PASS=false
    fi
elif command -v docker &> /dev/null; then
    if docker images | grep -q "demacu.*3.0"; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - Image 'demacu:3.0' not found in docker\n"
        PASS=false
    fi
else
    echo "⚠️  SKIP (no container runtime found)"
fi

# Check 2: Export file exists
echo -n "2. Checking if export file exists at /tmp/ckad-output/demacu.tar... "
if [ -f "/tmp/ckad-output/demacu.tar" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Export file /tmp/ckad-output/demacu.tar not found\n"
    PASS=false
fi

# Check 3: File is a valid archive
echo -n "3. Checking if export file is a valid tar archive... "
if [ -f "/tmp/ckad-output/demacu.tar" ]; then
    if tar -tf /tmp/ckad-output/demacu.tar &> /dev/null; then
        echo "✅ PASS"
    else
        echo "❌ FAIL"
        ERRORS+="   - File is not a valid tar archive\n"
        PASS=false
    fi
else
    echo "❌ SKIP (file not found)"
    PASS=false
fi

# Check 4: OCI format (check for oci-layout file)
echo -n "4. Checking if export is in OCI format... "
if [ -f "/tmp/ckad-output/demacu.tar" ]; then
    if tar -tf /tmp/ckad-output/demacu.tar 2>/dev/null | grep -q "oci-layout\|index.json"; then
        echo "✅ PASS"
    else
        echo "⚠️  WARNING (may be Docker format instead of OCI)"
        # Don't fail for this, but warn
    fi
else
    echo "❌ SKIP (file not found)"
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
