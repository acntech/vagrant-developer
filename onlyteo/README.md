# AcnTech Xubuntu onlyteo

AcnTech Xubuntu custom box based on [acntech/xubuntu-developer](https://app.vagrantup.com/acntech/boxes/xubuntu-developer) [v21.10.0](https://app.vagrantup.com/acntech/boxes/xubuntu-developer/versions/21.10.0).

## Customize

### Keyboard Layout
* Set keyboard layout to Norwegian: `sudo localectl set-x11-keymap no,us`

### Theme
* Create user specific themes folder: `~/.themes`
* Download theme archive from [www.xfce-look.org](https://www.xfce-look.org/p/1207818)
* Extract theme into themes folder: `tar -xvf ~/Downloads/PRO-dark-XFCE-4.14.tar.xz -C ~/.themes`
* Change theme in > Settings > Appearance > Style Tab

### Icons
* Add APT repository: `sudo add-apt-repository -u ppa:snwh/ppa`
* If the Xubuntu release isn't supported change it in `sudo vi /etc/apt/sources.list.d/snwh-ubuntu-ppa-<release>.list` to closest release, e.g. `impish` to `focal`
* APT update: `sudo apt update`
* APT install: `sudo apt install moka-icon-theme faba-icon-theme`
* Change icons in > Settings > Appearance > Icons Tab
