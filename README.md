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

* Git 2.20.1
* Docker 19.03.5 Community Edition
  * Docker Compose 1.24.1
* OpenJDK 13.0.1
  * Java Security RNG changed to /dev/urandom
* Apache Maven 3.6.2
* Apache Ant 1.10.7
* NodeJS 12.13.0
  * NPM 6.12.0
  * Yarn 1.19.1

The following tools are no longer pre-installed since they are available as a snap from the software marketplace.

* JetBrains IntelliJ
* Sublime Text Editor
* Postman
