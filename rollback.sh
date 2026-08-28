#! /bin/bash

set -e 

DEPLOYMENT="fixit"

echo "Checking rollout history..."
kubectl rollout history deployment/$DEPLOYMENT

echo ""
echo "Rolling back $DEPLOYMENT..."

kubectl rollout undo deployment/$DEPLOYMENT

echo ""
echo "Waiting for rollback to complete..."

kubectl rollout status deployment/$DEPLOYMENT

echo ""
echo "Rollback completed successfully."

echo ""
echo "Current image:"
kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}"

echo ""
echo ""
echo "Current Pods:"
kubectl get pods -l app=fixit
