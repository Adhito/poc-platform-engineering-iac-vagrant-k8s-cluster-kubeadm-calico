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


## Stage : Create Kubernetes Namespace & Kind 
# Apply ClusterRoleBinding
  cat <<EOF | sudo -i -u vagrant kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF


# ## Stage : Deploying The Dashboard & Print Out Token
# # Apply aio/deploy dashboard & print out token
#  echo "Stage : Deploying the dashboard..."
#  sudo -i -u vagrant kubectl apply -f "https://raw.githubusercontent.com/kubernetes/dashboard/v${DASHBOARD_VERSION}/aio/deploy/recommended.yaml"#
#   sudo -i -u vagrant kubectl -n kubernetes-dashboard get secret/admin-user -o go-template="{{.data.token | base64decode}}" >> "${config_path}/token"
#   echo "The following token was also saved to: configs/token"
#   cat "${config_path}/token"
#   echo "
# Use it to log in at:
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
# "
# fi

## Stage : Deploying The Dashboard & Print Out Token
# Apply adhito/deploy custom dashboard
  echo "Stage : Deploying the dashboard..."
  sudo -i -u vagrant kubectl apply -f "https://raw.githubusercontent.com/Adhito/poc-platform-engineering-iac-vagrant-k8s-cluster/main/scripts-kubernetes-ui-dashboard/kubernetes-dashboard-main.yaml"
  sudo -i -u vagrant kubectl apply -f "https://raw.githubusercontent.com/Adhito/poc-platform-engineering-iac-vagrant-k8s-cluster/main/scripts-kubernetes-ui-dashboard/kubernetes-dashboard-components.yaml"

  sudo -i -u vagrant kubectl -n kubernetes-dashboard get secret/admin-user -o go-template="{{.data.token | base64decode}}" >> "${config_path}/token"
  echo "The following token was also saved to: configs/token"
  cat "${config_path}/token"
  echo "
Use it to log in at:
https://localhost:30001
"
fi