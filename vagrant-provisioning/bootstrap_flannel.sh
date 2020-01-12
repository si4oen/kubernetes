#!/bin/bash

## Set TimeZone to Asia/Ho_Chi_Minh
echo "===== [TASK] Set TimeZone to Asia/Ho_Chi_Minh"
timedatectl set-timezone Asia/Ho_Chi_Minh

## Update the system >/dev/null 2>&1
echo "===== [TASK] Updating the system"
yum install -y epel-release >/dev/null 2>&1
yum update -y >/dev/null 2>&1

## Install desired packages
echo "===== [TASK] Installing desired packages"
yum install -y telnet htop net-tools wget nano >/dev/null 2>&1

## Enable password authentication
echo "===== [TASK] Enabled SSH password authentication"
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
systemctl reload sshd

## Set Root Password
echo "===== [TASK] Set root password"
echo "centos" | passwd --stdin root >/dev/null 2>&1

## Disable and Stop firewalld
echo "===== [TASK] Disable and stop firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

## Disable SELinux
echo "===== [TASK] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

## Install docker from Docker-ce repository
echo "===== [TASK] Install docker container engine"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1

## Enable docker service
echo "===== [TASK] Enable and start docker service"
systemctl daemon-reload
systemctl enable docker >/dev/null 2>&1
systemctl start docker

## Add sysctl settings
echo "===== [TASK] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

## Disable swap
echo "===== [TASK] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

## Add yum repo file for Kubernetes
echo "===== [TASK] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

## Install Kubernetes
echo "===== [TASK] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum install -y -q kubeadm kubelet kubectl >/dev/null 2>&1

## Start and Enable kubelet service
echo "===== [TASK] Enable and start kubelet service"
systemctl daemon-reload
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

## Update hosts file
echo "===== [TASK] Update host file /etc/hosts"
cat >>/etc/hosts<<EOF
192.168.16.130 kmaster.testlab.local kmaster
192.168.16.131 kworker1.testlab.local kworker1
192.168.16.132 kworker2.testlab.local kworker2
EOF

## Cleanup system >/dev/null 2>&1
echo "===== [TASK] Cleanup system"
package-cleanup -y --oldkernels --count=1 >/dev/null 2>&1
yum -y autoremove >/dev/null 2>&1
yum clean all >/dev/null 2>&1
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp
#dd if=/dev/zero of=/EMPTY bs=1M
#rm -f /EMPTY
cat /dev/null > ~/.bash_history && history -c
