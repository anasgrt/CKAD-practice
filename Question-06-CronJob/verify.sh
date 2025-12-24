#!/bin/bash
# Question 6: CronJob Configuration - Verification

PASS=true
ERRORS=""

echo "🔍 Checking your answer..."
echo ""

# Check 1: CronJob exists
echo -n "1. Checking CronJob 'log-cleaner' exists in namespace 'production'... "
if kubectl get cronjob log-cleaner -n production &> /dev/null; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - CronJob 'log-cleaner' not found\n"
    PASS=false
fi

# Check 2: Schedule is */30 * * * *
echo -n "2. Checking schedule is '*/30 * * * *'... "
SCHEDULE=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$SCHEDULE" = "*/30 * * * *" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Schedule is '$SCHEDULE', expected '*/30 * * * *'\n"
    PASS=false
fi

# Check 3: Container name is 'log'
echo -n "3. Checking container name is 'log'... "
CONTAINER_NAME=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$CONTAINER_NAME" = "log" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Container name is '$CONTAINER_NAME', expected 'log'\n"
    PASS=false
fi

# Check 4: Image is busybox
echo -n "4. Checking image is 'busybox'... "
IMAGE=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$IMAGE" == *"busybox"* ]]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Image is '$IMAGE', expected 'busybox'\n"
    PASS=false
fi

# Check 5: Command includes 'date'
echo -n "5. Checking command is 'date'... "
COMMAND=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].command}' 2>/dev/null)
if [[ "$COMMAND" == *"date"* ]]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Command is '$COMMAND', expected to include 'date'\n"
    PASS=false
fi

# Check 6: Completions is 2
echo -n "6. Checking completions=2... "
COMPLETIONS=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.completions}' 2>/dev/null)
if [ "$COMPLETIONS" = "2" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - Completions is '$COMPLETIONS', expected '2'\n"
    PASS=false
fi

# Check 7: backoffLimit is 3
echo -n "7. Checking backoffLimit=3... "
BACKOFF=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.backoffLimit}' 2>/dev/null)
if [ "$BACKOFF" = "3" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - backoffLimit is '$BACKOFF', expected '3'\n"
    PASS=false
fi

# Check 8: activeDeadlineSeconds is 30
echo -n "8. Checking activeDeadlineSeconds=30... "
DEADLINE=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
if [ "$DEADLINE" = "30" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - activeDeadlineSeconds is '$DEADLINE', expected '30'\n"
    PASS=false
fi

# Check 9: restartPolicy is OnFailure
echo -n "9. Checking restartPolicy=OnFailure... "
RESTART=$(kubectl get cronjob log-cleaner -n production -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null)
if [ "$RESTART" = "OnFailure" ]; then
    echo "✅ PASS"
else
    echo "❌ FAIL"
    ERRORS+="   - restartPolicy is '$RESTART', expected 'OnFailure'\n"
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
