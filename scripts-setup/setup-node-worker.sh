#!/bin/bash
# Shell Script Setup for All Nodes (Control Plane Node and Worker Node)


## Set End the script immediately if any command or pipe exits with a non-zero status.
set -euxo pipefail


## Set Configuration Path
config_path="/vagrant/configs"


## Set & Trigger Kubeadm Join Command
/bin/bash $config_path/setup-join.sh -v


## Set Node Label and Configuration for config.yaml file into kube config path 
sudo -i -u vagrant bash << EOF
whoami
mkdir -p /home/vagrant/.kube
sudo cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
