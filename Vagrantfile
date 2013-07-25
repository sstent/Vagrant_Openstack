
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "Centos64Puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  #config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  config.vm.define :puppet do |puppet_config|
          puppet_config.vm.hostname = "puppet.vagrant.info"
          puppet_config.vm.network :private_network, ip: "192.168.33.10" #eth1 MGMT
  end
  config.vm.define :controller do |controller_config|
          controller_config.vm.hostname = "controller.vagrant.info"
          controller_config.vm.network :private_network, ip: "192.168.33.11"  #eth1 MGMT
          controller_config.vm.network :private_network, ip: "10.10.1.11" #eth2 VM Traffic 
          controller_config.vm.network :private_network, ip: "10.10.2.11" #eth3 floating
          controller_config.vm.network :forwarded_port, guest: 80, host: 8080
          controller_config.vm.provision :shell, :inline => "ip link set mtu 1546 dev eth2"
          controller_config.vm.provider "virtualbox" do |controller_vbox|
            controller_vbox.customize ["modifyvm", :id, "--nicpromisc4", "allow-all", "--nictype4", "Am79C973"] # eth4
            controller_vbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all", "--nictype3", "Am79C973"] # eth3
          end


  end

  config.vm.define :compute1 do |compute1_config|
          compute1_config.vm.hostname = "compute1.vagrant.info"
          compute1_config.vm.network :private_network, ip: "192.168.33.12"  #eth1 MGMT
          compute1_config.vm.network :private_network, ip: "10.10.1.12" #eth2 VM Traffic
          #compute1_config.vm.provision :shell, :inline => "ip link set mtu 1546 dev eth2"
          #compute1_config.vm.provision :shell, :inline => "ip link set eth2 promisc on"

          compute1_config.vm.provider "virtualbox" do |compute1_vbox|
            compute1_vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all", "--nictype2", "Am79C973"] # eth2
            compute1_vbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all", "--nictype3", "Am79C973"] # eth3
            compute1_vbox.customize ["modifyvm", :id, "--cpus", 4]
            compute1_vbox.customize ["modifyvm", :id, "--memory", 2048]
          end

  end

    config.vm.provider "virtualbox" do |vbox|
      vbox.gui = false
    end

  config.vm.provision :puppet do |puppet|
       puppet.module_path = "modules"
       
       puppet.manifest_file  = "site.pp"
       puppet.options = "--verbose --debug"
  end

end
