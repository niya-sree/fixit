#! /bin/bash

set -e

DEPLOYMENT="fixit"
VERSION="${1:-v3}"

echo "---------------------------"
echo "Fixit Rolling Update..."
echo "---------------------------"

echo ""
echo "Deploying image: fixit:$VERSION"

kubectl set image deployment/$DEPLOYMENT \
  fixit=fixit:$VERSION

kubectl annotate deployment/$DEPLOYMENT \
  kubernetes.io/change-cause="Updated Fixit image to $VERSION" \
  --overwrite

echo ""
echo "Waiting for rollout..."

kubectl rollout status deployment/$DEPLOYMENT 

echo ""
echo "Rolling Update Completed Successfully."

echo ""
echo "Current image:"
kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}"

echo ""
echo "Current pods:"
kubectl get pods -l app=fixit





