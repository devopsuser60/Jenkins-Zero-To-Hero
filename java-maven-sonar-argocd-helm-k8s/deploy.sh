#!/bin/bash

set -e

BUILD_NUMBER="$1"

if [ -z "$BUILD_NUMBER" ]; then
    echo "ERROR: Build number is required"
    echo "Usage: ./deploy.sh <BUILD_NUMBER>"
    exit 1
fi

echo "=========================================="
echo " DEPLOYING BUILD: $BUILD_NUMBER"
echo "=========================================="

MANIFEST="spring-boot-app-manifests/deployment.yml"

echo "Updating Docker image tag..."

sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" "$MANIFEST"

echo "Updated manifest:"
grep "image:" "$MANIFEST"

echo "=========================================="
echo " APPLYING TO KUBERNETES"
echo "=========================================="

kubectl apply -f "$MANIFEST"

echo "=========================================="
echo " DEPLOYMENT COMPLETED"
echo "=========================================="

kubectl get pods
