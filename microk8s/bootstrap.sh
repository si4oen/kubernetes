#!/bin/bash

## Set TimeZone to Asia/Ho_Chi_Minh
echo ">>>>> [TASK] Set TimeZone to Asia/Ho_Chi_Minh"
timedatectl set-timezone Asia/Ho_Chi_Minh

## Update the system >/dev/null 2>&1
echo ">>>>> [TASK] Updating the system"
apt update >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1

## Install desired packages
echo ">>>>> [TASK] Installing desired packages"
apt install -y elinks net-tools telnet htop wget unzip >/dev/null 2>&1

## Enable password authentication & SSH root login
echo ">>>>> [TASK] Enabled password authentication in sshd config"
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
systemctl reload sshd

## Enable SSH root login
echo ">>>>> [TASK] Enable SSH root login"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl reload sshd

## Set Root Password
echo ">>>>> [TASK] Set root password"
echo "root:ubuntu" | sudo chpasswd >/dev/null 2>&1

## Install microk8s on Ubuntu
echo ">>>>> [TASK] Install microk8s on Ubuntu"
apt-get install -y snapd >/dev/null 2>&1
snap install microk8s --classic

## Update hosts file
echo ">>>>> [TASK] Update host file /etc/hosts"
cat >>/etc/hosts<<EOF
192.168.16.161 gitlab1.testlab.local gitlab1
192.168.16.151 docker1.testlab.local docker1
192.168.16.141 jenkins1.testlab.local jenkins1
192.168.16.130 kmaster.testlab.local kmaster
192.168.16.131 kworker1.testlab.local kworker1
192.168.16.132 kworker2.testlab.local kworker2
192.168.16.133 microk8s.testlab.local microk8s
EOF

## Cleanup system >/dev/null 2>&1
echo ">>>>> [TASK] Cleanup system"
apt-get --purge autoremove -y >/dev/null 2>&1
apt-get autoremove -y >/dev/null 2>&1
apt-get clean >/dev/null 2>&1
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp
#dd if=/dev/zero of=/EMPTY bs=1M
#rm -f /EMPTY
cat /dev/null > ~/.bash_history && history -c
