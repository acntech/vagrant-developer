# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Name of Vagrant Box
  config.vm.box = "acntech/ubuntu"

  # Don't generate new SSH key, but use the default insecure key
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM
    vb.memory = "2048"

    # Customize CPU count
    vb.cpus = "1"

    # Name to display in Virtualbox
    vb.name = "AcnTech Ubuntu Developer"
  end

  # Update packages
  config.vm.provision "shell", inline: "DEBIAN_FRONTEND=noninteractive /vagrant/bin/provision.sh"
end
