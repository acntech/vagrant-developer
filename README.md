# AcnTech Developer
The AcnTech Developer Vagrant box is a premade image containing typical developer tool and utils.

Created with Vagrant 2.1.2 and VirtualBox 5.2.18.

The box comes in two flavors, one based on Ubuntu and one based on Xubuntu.

### AcnTech Ubuntu Developer
See details in folder [/ubuntu](/ubuntu).

### AcnTech Xubuntu Developer
See details in folder [/xubuntu](/xubuntu).

### Prerequisites
The host computer must have _Intel VT/AMD-V_ virtualization support enabled in the BIOS.

[Oracle VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com) must also be installed on the host.

### Installed tools
The box has the following developer tools installed.

* Git 2.17.1
* Docker 18.09.0 Community Edition
* Docker Compose 1.23.1
* Oracle Java JDK 8u191
  * Java Security RNG changed to /dev/urandom
* Apache Maven 3.6.0
* NodeJS 10.13.0
* JetBrains IntelliJ 2018.2.6 Community Edition
* Sublime 3.1.1
* Postman 6.5.2
