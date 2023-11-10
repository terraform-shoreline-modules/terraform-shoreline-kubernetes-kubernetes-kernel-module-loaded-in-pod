#!/bin/bash

# Set the variables
NAMESPACE=${NAMESPACE}
POD_NAME=${POD_NAME}

# Delete the pod
kubectl delete pod $POD_NAME -n $NAMESPACE

# Check if the pod is deleted successfully
if kubectl get pod $POD_NAME -n $NAMESPACE &> /dev/null; then
  echo "Error: $POD_NAME is still running in $NAMESPACE namespace."
  exit 1
else
  echo "Success: $POD_NAME is deleted from $NAMESPACE namespace."
fi