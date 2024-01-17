#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <pod-name>"
  exit 1
fi

pod_name="$1"

containers=$(oc get pod "$pod_name" -o jsonpath='{.spec.containers[*].name}')

for container in $containers; do
  echo "Logs for container '$container' in pod '$pod_name':"
  oc logs "$pod_name" -c "$container"
  echo "-----------------------------------------"
done
