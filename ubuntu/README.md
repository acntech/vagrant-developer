# AcnTech Ubuntu Developer
AcnTech Ubuntu Developer box based on [acntech/ubuntu](https://app.vagrantup.com/acntech/boxes/ubuntu) [v21.10.0](https://app.vagrantup.com/acntech/boxes/ubuntu/versions/21.10.0).

Created with Vagrant 2.2.19 and VirtualBox 6.1.30.

### Usage
See box on Vagrant Cloud: [acntech/ubuntu-developer](https://app.vagrantup.com/acntech/boxes/ubuntu-developer).

See code on GitHub: [acntech/vagrant-developer](https://github.com/acntech/vagrant-developer).

Create a ```Vagrantfile``` with the following content inside an empty folder:
```
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/ubuntu-developer"
end
```

Start the box by issuing the following command from the command line inside the folder:
```
vagrant up
```
