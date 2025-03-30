#!/bin/bash
#
# Deploys ArgoCD on a Kubernetes cluster

set -euxo pipefail

# Set Config Path
config_path="/vagrant/configs"

# Define ArgoCD namespace
ARGOCD_NAMESPACE="argocd"

# Stage: Deploy ArgoCD
ARGOCD_VERSION=$(grep -E '^\s*argocd:' /vagrant/settings.yaml | sed -E -e 's/[^:]+: *//' -e 's/\r$//')
if [ -n "${ARGOCD_VERSION}" ]; then
  echo "Stage : Installing ArgoCD..."
  
  sudo -i -u vagrant kubectl create namespace ${ARGOCD_NAMESPACE} || true

  sudo -i -u vagrant kubectl apply -n ${ARGOCD_NAMESPACE} -f "https://raw.githubusercontent.com/argoproj/argo-cd/v${ARGOCD_VERSION}/manifests/install.yaml"
  
  echo "Stage : Waiting for ArgoCD to be ready..."
    while sudo -i -u vagrant kubectl get pods -n ${ARGOCD_NAMESPACE} | awk '$3 != "Running" && $3 != "Completed" {exit 1}'; do
        sleep 5
    done


  echo "Stage : Creating ArgoCD admin user..."
  
  sudo -i -u vagrant kubectl patch svc argocd-server -n ${ARGOCD_NAMESPACE} -p '{"spec": {"type": "NodePort", "ports": [{"port": 80, "targetPort": 8080, "nodePort": 30002}]}}'

  ARGOCD_PASSWORD=$(sudo -i -u vagrant kubectl -n ${ARGOCD_NAMESPACE} get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
  echo "ArgoCD admin password: ${ARGOCD_PASSWORD}"
  echo "${ARGOCD_PASSWORD}" > "${config_path}/credentials_argocd_admin_password"
  
  echo "The following password was also saved to: ${config_path}/credentials_argocd_admin_password"
  echo "\nUse the following link to access ArgoCD UI:"
  echo "https://localhost:30002"
fi
