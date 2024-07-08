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


