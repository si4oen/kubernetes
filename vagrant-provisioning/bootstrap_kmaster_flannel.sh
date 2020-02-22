#!/bin/bash

# Initialize Kubernetes
echo ">>>>> [TASK] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.16.130 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo ">>>>> [TASK] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo ">>>>> [TASK] Deploy flannel network"
#su - vagrant -c "kubectl create -f ~/kube-flannel.yaml" 2>/dev/null
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

# Generate Cluster join command
echo ">>>>> [TASK] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
