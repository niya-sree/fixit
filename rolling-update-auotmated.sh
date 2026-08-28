#!/bin/bash

set -e

DEPLOYMENT="fixit"
CONTAINER="fixit"
IMAGE="fixit"

echo "--------------------------------------"
echo "Fixit Automated Deployment"
echo "--------------------------------------"

# Find the currently deployed image
CURRENT_IMAGE=$(kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}")

echo ""
echo "Current image: $CURRENT_IMAGE"

# Extract current version number
CURRENT_VERSION=$(echo "$CURRENT_IMAGE" | sed 's/.*:v//')

# Default to v1 if no version is found
if ! [[ "$CURRENT_VERSION" =~ ^[0-9]+$ ]]; then
    CURRENT_VERSION=1
fi

# Calculate next version
NEXT_VERSION=$((CURRENT_VERSION + 1))

echo "Next version: v$NEXT_VERSION"

# Build Docker image
echo ""
echo "Building Docker image..."
docker build -t "$IMAGE:v$NEXT_VERSION" .

# Load image into Docker Desktop Kubernetes
echo ""
echo "Loading image into Kubernetes..."
docker save "$IMAGE:v$NEXT_VERSION" | \
  docker exec -i desktop-control-plane ctr -n k8s.io images import -

# Update Deployment
echo ""
echo "Updating Deployment..."
kubectl set image deployment/$DEPLOYMENT \
  $CONTAINER=$IMAGE:v$NEXT_VERSION

# Record rollout change
kubectl annotate deployment/$DEPLOYMENT \
  kubernetes.io/change-cause="Updated Fixit image to v$NEXT_VERSION" \
  --overwrite

# Wait for rolling update
echo ""
echo "Waiting for rolling update..."
kubectl rollout status deployment/$DEPLOYMENT

echo ""
echo "--------------------------------------"
echo "Deployment Successful"
echo "--------------------------------------"

echo ""
echo "Current image:"
kubectl get deployment/$DEPLOYMENT \
  -o=jsonpath="{.spec.template.spec.containers[0].image}"

echo ""

echo ""
echo "Current Pods:"
kubectl get pods -l app=fixit

