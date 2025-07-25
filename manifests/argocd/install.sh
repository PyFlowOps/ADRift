#!/usr/bin/env bash
# This script installs ADRift and its dependencies in a Kubernetes cluster.

set -eou pipefail

# This script assumes that kubectl and kustomize are installed and configured.
# Namespace installation
kubectl apply -f namespace.yaml

# Let's get the prerequisites ready
echo "[INFO] - Installing prerequisites..."
kustomize build prereqs | kubectl apply -f - > /dev/null 2>&1 || true
sleep 3

# Install PostgreSQL
echo "[INFO] - Installing PostgreSQL..."
kustomize build postgres | kubectl apply -f - > /dev/null 2>&1 || true

# Install ADRift
echo "[INFO] - Installing ADRift..."
kustomize build overlays | kubectl apply -f - > /dev/null 2>&1 || true

echo "[COMPLETE] - ADRrift and its dependencies have been successfully installed!"
