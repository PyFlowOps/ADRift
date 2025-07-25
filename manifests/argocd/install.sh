#!/usr/bin/env bash
# This script installs ADRift and its dependencies in a Kubernetes cluster.

set -eou pipefail

# This script assumes that kubectl and kustomize are installed and configured.
# Namespace installation
kubectl apply -f namespace.yaml

# Check if the namespace was created successfully
python -m pip install -r scripts/requirements.txt
python scripts/patch-render.py # This gets the environment variables set up correctly for the ADRift application

if [[ $? -ne 0 ]]; then
    echo "[ERROR] - Failed to render ADRift application patches. Please check the script output."
    exit 1
fi

# Let's get the prerequisites ready
echo "[INFO] - Installing prerequisites..."
kustomize build prereqs | kubectl apply -f - > /dev/null 2>&1 || true
sleep 3

# We need to install the PostgreSQL storage first
kubectl apply -f prereqs/postgres-pv.yaml > /dev/null 2>&1 || true
sleep 3

kubectl apply -f prereqs/postgres-pvc.yaml > /dev/null 2>&1 || true
sleep 3

# Install PostgreSQL
echo "[INFO] - Installing PostgreSQL..."
kustomize build postgres | kubectl apply -f - > /dev/null 2>&1 || true
sleep 3

# Install ADRift
echo "[INFO] - Installing ADRift..."
kustomize build overlays | kubectl apply -f - > /dev/null 2>&1 || true
sleep 3

echo "[COMPLETE] - ADRrift and its dependencies have been successfully installed!"
