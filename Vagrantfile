
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "Centos64Puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.define :puppet do |puppet_config|
          puppet_config.vm.host_name = "puppet.vagrant.info"
          puppet_config.vm.network :hostonly, "192.168.33.10" #eth1 MGMT
  end
  config.vm.define :controller do |controller_config|
          controller_config.vm.host_name = "controller.vagrant.info"
          controller_config.vm.network :hostonly, "192.168.33.11"  #eth1 MGMT
          controller_config.vm.network :hostonly, "10.0.1.11" #eth2 VM Traffic 
          controller_config.vm.network :hostonly, "10.0.2.11" #eth3 floating
          controller_config.vm.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"] # eth3
          controller_config.vm.provision :shell, :inline => "ip link set mtu 1546 dev eth2"
          controller_config.vm.forward_port 80, 8080
  end

  config.vm.define :compute1 do |compute1_config|
          compute1_config.vm.host_name = "compute1.vagrant.info"
          compute1_config.vm.network :hostonly, "192.168.33.12"  #eth1 MGMT
          compute1_config.vm.network :hostonly, "10.0.1.12"
          compute1_config.vm.provision :shell, :inline => "ip link set mtu 1546 dev eth2"
	  compute1_config.vm.customize ["modifyvm", :id, "--memory", 2048]
	  compute1_config.vm.customize ["modifyvm", :id, "--cpus", 4]

  end

  config.vm.boot_mode = :headless

  config.vm.provision :puppet do |puppet|
       puppet.manifests_path = "manifests"
       puppet.module_path = "modules"
       
       puppet.manifest_file  = "site.pp"
       puppet.options = "--verbose --debug"
  end

end
