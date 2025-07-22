#!/usr/bin/env bash
# This script removes ADRift and its dependencies in a Kubernetes cluster.

set -eou pipefail

echo "[INFO] - Removing ADRift and its dependencies..."

# This script assumes that kubectl and kustomize are installed and configured.
echo "[INFO] - Removing PostgreSQL Service and its dependencies..."
kubectl delete namespace adrift > /dev/null 2>&1

echo "[INFO] - Removed ADRift and its dependencies..."
