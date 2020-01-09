#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "===== [TASK] Join node(s) to Kubernetes Cluster"
yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "centos" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.testlab.local:/joincluster.sh /joincluster.sh 2>/dev/null
bash /joincluster.sh >/dev/null 2>&1