#!/bin/bash
# Shell Script Setup for All Nodes (Control Plane Node and Worker Node)


## Set End the script immediately if any command or pipe exits with a non-zero status.
set -euxo pipefail


## Set Configuration Path
config_path="/vagrant/configs"