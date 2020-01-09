# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "box.centos7"
    kmaster.vm.hostname = "kmaster.testlab.local"
    kmaster.vm.network "public_network", ip: "192.168.16.130"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 2048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
    #kmaster.vm.provision "shell", path: "bootstrap_kmaster.sh"
  end

  NodeCount = 2
  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.box = "box.centos7"
      workernode.vm.hostname = "kworker#{i}.testlab.local"
      workernode.vm.network "private_network", ip: "192.168.16.13#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 1024
        v.cpus = 1
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      #workernode.vm.provision "shell", path: "bootstrap_kworker.sh"
    end
  end
end