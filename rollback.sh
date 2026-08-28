#! /bin/bash

set -e

DEPLOYMENT="fixit"

echo "--------------------------------------"
echo "Fixit Deployment Rollback"
echo "--------------------------------------"

echo ""
echo "Current image:"
kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}"
echo ""

echo ""
echo "Checking rollout history..."
kubectl rollout history deployment/$DEPLOYMENT

if [ -z "$1" ]; then
    echo ""
    echo "rolling back to previous revision..."
    kubectl rollout undo deployment/$DEPLOYMENT

else

    echo ""
    echo "Rolling back to revison $1..."
    kubectl rollback undo deployment/$DEPLOYMENT --to-revision="$1"
fi

echo ""
echo "Waiting for rollout to complete..."

kubectl rollout status deployment/$DEPLOYMENT

echo ""
echo "-------------------------------------------"
echo "Rollback Completed Successfully"
echo "-------------------------------------------"

echo ""
echo "Current image:"
kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}"
echo ""

echo ""
echo "Current Pods:"
kubectl get pods -l app=fixit



