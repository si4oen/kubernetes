# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  #disable default /vagrant share
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  ##ssh key-based authentication
  config.ssh.insert_key = false
  config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

  ##If install VirtualBox Guest Additions set auto_update to "TRUE" or running command "vagrant vbguest --do install"
  ##must install ==> vagrant plugin install vagrant-vbguest
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true
  end

  ##run bootstrap script
  config.vm.provision "shell", path: "bootstrap.sh"

  NodeCount = 1
    (1..NodeCount).each do |i|
    config.vm.define "uvm0#{i}" do |node|
      node.vm.box = "ubuntu/bionic64"
      node.vm.hostname = "uvm0#{i}.testlab.local"
      node.vm.network "public_network", ip: "192.168.16.15#{i}", bridge: "eno1"
      node.vm.provider "virtualbox" do |v|
        v.name = "uvm0#{i}"
        v.memory = 2048
        v.cpus = 2
	    v.customize ["modifyvm", :id, "--audio", "none"]
      end
    end
  end
end
