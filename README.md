# Project Platform Engineering IaC Vagrant K8s Cluster
Provision Kubernetes Cluster (K8S) systematically using Infrastructure as a Code (Vagrant) instead provisioning it manually.


## Prerequisites
* Oracle VirtualBox
* Hashicorp Vagrant
* Helmchart
* Kubectl



## To Provision the Cluster
Clone the repo and execute the following commands.

```shell
git clone https://github.com/Adhito/poc-platform-engineering-iac-vagrant-k8s-cluster-kubeadm-calico
cd project-platform-engineering-iac-vagrant-k8s-cluster
vagrant up
```

## To Shutdown The Cluster,
Refer to this link for vagrant halt documentation [vagrant halt](https://developer.hashicorp.com/vagrant/docs/cli/halt)

```shell
vagrant halt
```

## To Restart The Cluster,
Refer to this link for vagrant up documentation [vagrant up](https://developer.hashicorp.com/vagrant/docs/cli/up)

```shell
vagrant up
```

## To Destroy The Cluster,
Refer to this link for vagrant destroy documentation [vagrant destroy](https://developer.hashicorp.com/vagrant/docs/cli/destroy)

```shell
vagrant destroy -f
```
## TODO
### To-Do Backlog

- [ ] Create SVC For ArgoCD WebUI with LoadBalancer Type
- [ ] Some-task - 01 
- [ ] Some-task - 02
  - [ ] Sub-task 01

### To-Do In Progress

- [ ] -

### To-Do Completed ✓

- [x] Create SVC For ArgoCD WebUI with NodePort Type 