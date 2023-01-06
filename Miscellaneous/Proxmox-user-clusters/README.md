
# Terraform Proxmox Clusters

This repo contains an example config for creating a battery of 10 single or multi-node clusters to be used in trainings

This repo is intended to demonstrate some Terraform principles and best practices

## 2 sample configs are provided

#### terraform.tfvars.k8s-10clusters-2node

This config depends upon scripts at https://github.com/mjbright/k8s-scenarios/, notably the k8s-installer.sh script.

As configured it create 10 Kubernetes clusters, each with 1 control-plane and 1 worker node.

It has been tested with commit 41409fc7dacd4d050932e390bc19f114904de255 at:
- https://github.com/mjbright/k8s-scenarios/tree/41409fc7dacd4d050932e390bc19f114904de255/scripts

2 bash scripts are required:
- https://github.com/mjbright/k8s-scenarios/blob/41409fc7dacd4d050932e390bc19f114904de255/scripts/k8s-installer.sh
- https://github.com/mjbright/k8s-scenarios/blob/41409fc7dacd4d050932e390bc19f114904de255/scripts/k8s-installer.sh.fn

#### terraform.tfvars.tf-10-node

As configured it create 10 single-node clusters with no particular software installed


