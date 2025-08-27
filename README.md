# Project Platform Engineering IaC Vagrant K8s Cluster
Provision Kubernetes Cluster (K8S) systematically using Infrastructure as a Code (Vagrant) instead provisioning it manually. This POC is inspired by Kelsey Hightower ["Kubernetes The Hard Way"](https://github.com/kelseyhightower/kubernetes-the-hard-way) and meant as a sandbox ground to learn K8S




## Prerequisites Tools Used

| Tool               | Version  | Download Link                                                                 |
|--------------------|----------|-------------------------------------------------------------------------------|
| Oracle VirtualBox  | 7.0      | [Download](https://www.virtualbox.org/wiki/Downloads)                         |
| HashiCorp Vagrant  | 2.4.1    | [Download](https://developer.hashicorp.com/vagrant/downloads)                 |
| Helm               | Latest   | [Download](https://helm.sh/docs/intro/install/)                               |
| kubectl            | Latest   | [Download](https://kubernetes.io/docs/tasks/tools/#kubectl)                   |



## Stage : Provision the Cluster
Clone the repo and execute the following commands.

1. **Clone the repository:**
    ```shell
    git clone https://github.com/Adhito/poc-platform-engineering-iac-vagrant-k8s-cluster-kubeadm-calico
    ```

2. **Change the directory:**
    ```shell
    cd project-platform-engineering-iac-vagrant-k8s-cluster
    ```

3. **Start the cluster**
    ```shell
    vagrant up
    ```

## Stage : Shutting Down The Cluster,
Refer to this link for vagrant halt documentation [vagrant halt](https://developer.hashicorp.com/vagrant/docs/cli/halt)

* **Stop the cluster :**

    ```shell
    vagrant Halt
    ```

* **Destroy the cluster: (Optional)**

    ```shell
    vagrant destroy -f
    ```

## Stage : Restarting The Cluster,
Refer to this link for vagrant halt documentation [vagrant halt](https://developer.hashicorp.com/vagrant/docs/cli/halt)

* **Stop the cluster :**

    ```shell
    vagrant Halt
    ```

* **Start the cluster:**

    ```shell
    vagrant up
    ```



## TODO
### To-Do Backlog

- [ ] Create SVC For ArgoCD WebUI with LoadBalancer Type
- [ ] Some-task - 01 
- [ ] Some-task - 02
  - [ ] Sub-task 01

### To-Do In Progress

- [ ] Some-task - 01 
- [ ] Some-task - 02

### To-Do Completed ✓

- [x] Create SVC For ArgoCD WebUI with NodePort Type 
