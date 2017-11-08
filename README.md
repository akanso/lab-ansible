---
layout: post
title:  "Deploying k8s using kube-adm"
date:   2017-11-07 10:00:39 -0400
author: Ali Kanso
---

# Ansible Introduction

This repo provides a basic introduction to ansible

# Objective

The target audience are developers/admins that wish to automate their infrastructure.

In this lab we will create a vagrant cluster of 1 master-node with ansible installed and a number of worker-nodes

We will also create ansible playbook consisting of multiple roles deploying multiple applications

## Deploying a vagrant-cluster 
### Prerequisites (before you start k8s deployment):

Start by cloning this repo:

`git clone git@github.com:akanso/lab-ansible.git`

Make sure you have [`virtualbox`](https://www.virtualbox.org/wiki/Downloads) installed on your machine (tested on versions >= 5.1.26r117224).

Make sure you have `vagrant` installed (tested on 1.8 and 2.0).

Make sure the `hostmanager` plug in is installed using:

`vagrant plugin install vagrant-hostmanager`


### Provisioning the VMs and deploy k8s (all in one install):

Simply move to the directory where the `Vagrantfile` resides and execute a vagrant up command:

```shell
cd lab-ansible
vagrant up
```

This should take a few minutes, after which one master and 2 worker k8s nodes will be deployed

```shell
vagrant status

master-node               running (virtualbox)
worker-node1              running (virtualbox)
worker-node2              running (virtualbox)
```

you can `ssh` into the master-node and check the cluster status:

```shell
vagrant ssh master-node
cd /vagrant
ansible all -i hosts -m ping
```

you should see a response from both nodes

```shell
worker-node1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
worker-node2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Customizing the cluster provisioning in terms of the number/size of the VMs

The configuration file [vg_config.rb](https://github.com/akanso/lab-ansible/blob/master/vg_config.rb)

You can change the values of all the variables in this file, e.g.:

```shell
cat vg_config.rb
$worker_vm_count=2
$worker_vm_memory=1536
$worker_vm_cpu=1
...
```
