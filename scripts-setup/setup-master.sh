#!/bin/bash
#


## Stage : Setup for Control Plane (Master) servers
# Variable that needed to be passed $CONTROL_IP, $CONTROL_IP, $POD_CIDR, $SERVICE_CIDR, $NODENAME

set -euxo pipefail

NODENAME=$(hostname -s)

sudo kubeadm config images pull

echo "Stage : Preflight Check Passed, Downloaded All Required Images"

sudo kubeadm init --apiserver-advertise-address=$CONTROL_IP --apiserver-cert-extra-sans=$CONTROL_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

mkdir -p "$HOME"/.kube

sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config

sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config


## Stage : Save Configs to shared /Vagrant location
# For Vagrant re-runs, check if there is existing configs in the location and delete it for saving new configuration.

config_path="/vagrant/configs"

if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf $config_path/config

touch $config_path/setup-join.sh

chmod +x $config_path/setup-join.sh

kubeadm token create --print-join-command > $config_path/setup-join.sh