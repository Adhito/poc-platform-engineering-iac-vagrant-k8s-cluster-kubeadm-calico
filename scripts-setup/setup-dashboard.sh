#!/bin/bash
#

## Stage : Deploy Kubernetes Dashboard
# Deploys the Kubernetes dashboard when enabled in settings.yaml


## Set End the script immediately if any command or pipe exits with a non-zero status.
set -euxo pipefail


## Set Config Path
config_path="/vagrant/configs"


## Stage : Apply Kubernetes Dashboard
# Logic to wait for the metric server to be ready
DASHBOARD_VERSION=$(grep -E '^\s*dashboard:' /vagrant/settings.yaml | sed -E -e 's/[^:]+: *//' -e 's/\r$//')
if [ -n "${DASHBOARD_VERSION}" ]; then
  while sudo -i -u vagrant kubectl get pods -A -l k8s-app=metrics-server | awk 'split($3, a, "/") && a[1] != a[2] { print $0; }' | grep -v "RESTARTS"; do
    echo 'Stage : Waiting for metrics server to be ready...'
    sleep 5
  done
  echo 'Stage : Metrics server is ready. Installing dashboard...'

  sudo -i -u vagrant kubectl create namespace kubernetes-dashboard

  echo "Stage : Creating the dashboard user..."


## Stage : Create Kubernetes Namespace & Kind 
# Apply ServiceAccount
    cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF


## Stage : Create Kubernetes Namespace & Kind 
# Apply Secret
  cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
EOF