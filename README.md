# AcnTech Developer
The AcnTech Developer Vagrant box is a premade image containing typical developer tool and utils.

The box comes in two flavors, one based on Ubuntu and one based on Xubuntu.

### AcnTech Ubuntu Developer
See details in folder [/ubuntu](/ubuntu).

### AcnTech Xubuntu Developer
See details in folder [/xubuntu](/xubuntu).

### Prerequisites
The host computer must have _Intel VT/AMD-V_ virtualization support enabled in the BIOS.

[Oracle VirtualBox](https://www.virtualbox.org) and [Vagrant](https://www.vagrantup.com) must also be installed on the host.

### Installed tools
The box has the following developer tools installed using the `default` puppet environment.

* Git
* Docker Community Edition
  * Docker Compose
* OpenJDK Temurin
* Apache Ant
* Apache Maven
* NodeJS
  * NPM
  * Yarn

The following tools can be installed using the `extended` puppet environment. They are also available as a snap from the software marketplace.

* JetBrains IntelliJ Ultimate
* Visual Studio Code
* Sublime Text Editor
* Postman
