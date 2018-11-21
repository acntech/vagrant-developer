# AcnTech Xubuntu Developer
AcnTech Xubuntu Developer box based on [acntech/xubuntu](https://app.vagrantup.com/acntech/boxes/xubuntu) v2.0.0 with Xubuntu Desktop 18.04.1 LTS 64-bit installed on a 100 GB disk.

Created with Vagrant 2.1.2 and VirtualBox 5.2.18.

### Prerequisites
The host computer must have _Intel VT/AMD-V_ virtualization support enabled in the BIOS.

[Oracle VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com) must also be installed on the host.

### Usage
See box on Vagrant Cloud: [acntech/xubuntu-developer](https://app.vagrantup.com/acntech/boxes/xubuntu-developer).

See code on GitHub: [acntech/vagrant-developer](https://github.com/acntech/vagrant-developer).

Create a ```Vagrantfile``` with the following content inside an empty folder:
```
Vagrant.configure("2") do |config|
  config.vm.box = "acntech/xubuntu-developer"
end
```

Start the box by issuing the following command from the command line inside the folder:
```
vagrant up
```

### Installed tools
The box has the following developer tools installed.

* Git 2.17.1
* Docker 18.09.0 Community Edition
* Docker Compose 1.23.1
* Oracle Java JDK 8u191
  * Java Security RNG changed to /dev/urandom
* Apache Maven 3.6.0
* NodeJS 10.12.0
* JetBrains IntelliJ 2018.2.6 Community Edition