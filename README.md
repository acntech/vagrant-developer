# AcnTech Developer
The AcnTech Developer Vagrant box is a premade image containing typical developer tool and utils.

Created with Vagrant 2.2.6 and VirtualBox 6.0.14.

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

* Git
* Docker Community Edition
  * Docker Compose
* OpenJDK
  * Java Security RNG changed to /dev/urandom
* Apache Maven
* Apache Ant
* NodeJS
  * NPM
  * Yarn

The following tools are no longer pre-installed since they are available as a snap from the software marketplace.

* JetBrains IntelliJ
* Sublime Text Editor
* Postman
