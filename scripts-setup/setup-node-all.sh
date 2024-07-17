#!/bin/bash
# Shell Script Setup for All Nodes (Control Plane Node and Worker Node)


## Set End the script immediately if any command or pipe exits with a non-zero status.
set -euxo pipefail


## Stage : Configuration For DNS 
# Variable that needed to be passed = ${DNS_SERVERS}
if [ ! -d /etc/systemd/resolved.conf.d ]; then
	sudo mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=${DNS_SERVERS}
EOF
## Restart network name resolution services (systemd-resolved)
sudo systemctl restart systemd-resolved
echo "Stage : Configuration For DNS Completed"


## Stage : Configuration To Disable Swap & Persist After Reboot 
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y
echo "Stage : Configuration To Disable Swap & Persist After Reboot Completed"


## Stage : Configuration For The .conf File To Load The Modules At Bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
echo "Stage : Configuration For The .conf File To Load The Modules At Bootup Completed"


## Stage : Configuration For IP Tables sysctl params Required By Steup & Persist After Reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
## Restart & Apply sysctl params Without Reboot
sudo sysctl --system
echo "Stage : Configuration For IP Tables sysctl params Required By Steup & Persist After Reboots Completed"


## Stage : Configuration To Install CRI-O Container Runtime
# Variable that needed to be passed = ${KUBERNETES_VERSION}
sudo apt-get update -y
apt-get install -y software-properties-common curl apt-transport-https ca-certificates

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update -y
sudo apt-get install -y cri-o

sudo systemctl daemon-reload
sudo systemctl enable crio --now
sudo systemctl start crio.service

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION_SHORT/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION_SHORT/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y
sudo apt-get install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
sudo apt-get update -y
sudo apt-get install -y jq
echo "Stage : Configuration To Install CRI-O Container Runtime"


## Stage : Configuration To Disable auto-update services
## Hold version for kubelet, kubectl, kubeadm & CRI-O
sudo apt-mark hold kubelet kubectl kubeadm cri-o


## Stage : Configuration Set Local IP
## Set local ip on all kubeneretes node-control-plane & node-worker
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
${ENVIRONMENT}
EOF
