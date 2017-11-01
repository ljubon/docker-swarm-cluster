# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/trusty64"
    config.vm.provision "shell", path: "provision/node.sh", privileged: true

    # Managers
    (1..2).each do |number|
        config.vm.define "m#{number}" do |node|
            node.vm.network "private_network", ip: "192.168.99.20#{number}"
              virtualbox__intnet = "NAT-cluster"
            node.vm.hostname = "m#{number}"
        end  
    end

    # Workers
    (1..4).each do |number|
        config.vm.define "w#{number}" do |node|
            node.vm.network "private_network", ip: "192.168.99.21#{number}"
              virtualbox__intnet = "NAT-cluster"
            node.vm.hostname = "w#{number}"
        end  
    end

    config.vm.provider "virtualbox" do |v|
        v.memory = 1048 
        v.cpus = 1
    end

end