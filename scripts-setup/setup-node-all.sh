#!/bin/bash
# Shell Script Setup for All VM (VM Control Plane and VM Worker Nodes)


## Set End the script immediately if any command or pipe exits with a non-zero status.
set -euxo pipefail


## Configuration For DNS 
if [ ! -d /etc/systemd/resolved.conf.d ]; then
	sudo mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=${DNS_SERVERS}
EOF


## Restart network name resolution services (systemd-resolved)
sudo systemctl restart systemd-resolved


## Configuration To Disable Swap & Persist After Reboot 
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y


## Configuration For The .conf File To Load The Modules At Bootup
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter


## Configuration For IP Tables sysctl params Required By Steup & Persist After Reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF


## Restart & Apply sysctl params Without Reboot
sudo sysctl --system