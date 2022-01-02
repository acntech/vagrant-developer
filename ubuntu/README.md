# AcnTech Ubuntu Developer
AcnTech Ubuntu Developer box based on [acntech/ubuntu](https://app.vagrantup.com/acntech/boxes/ubuntu).

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
