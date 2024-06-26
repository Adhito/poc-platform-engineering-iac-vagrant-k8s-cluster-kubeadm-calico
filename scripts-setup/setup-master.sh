#!/bin/bash
#


## Stage : Setup for Control Plane (Master) servers

set -euxo pipefail

NODENAME=$(hostname -s)

sudo kubeadm config images pull

echo "Stage : Preflight Check Passed, Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$CONTROL_IP --apiserver-cert-extra-sans=$CONTROL_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube

sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config

sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
