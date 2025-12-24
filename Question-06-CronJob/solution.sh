#!/bin/bash
#===============================================================================
# SOLUTION: Question 6 - CronJob with Completions & Retry Limits
#===============================================================================

# Create CronJob manifest
cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: log-cleaner
  namespace: production
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      completions: 2
      backoffLimit: 3
      activeDeadlineSeconds: 30
      template:
        spec:
          containers:
          - name: log
            image: busybox
            command: ["date"]
          restartPolicy: OnFailure
EOF

# Verify CronJob was created
kubectl get cronjob log-cleaner -n production

# Test by manually triggering a job
kubectl create job --from=cronjob/log-cleaner manual-test -n production

# Check the job and pods
kubectl get jobs -n production
kubectl get pods -n production

# Check logs
kubectl logs -l job-name=manual-test -n production

#===============================================================================
# KEY POINTS:
#===============================================================================
# 1. schedule: "*/30 * * * *" = every 30 minutes
# 2. completions: 2 = job must succeed 2 times
# 3. backoffLimit: 3 = max 3 retries on failure
# 4. activeDeadlineSeconds: 30 = kill after 30 seconds
# 5. restartPolicy: OnFailure (required for jobs, can't be Always)
# 6. Test with: kubectl create job --from=cronjob/<n> <job-name>
#===============================================================================
