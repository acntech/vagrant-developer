class system (
  $packages = [
    "dkms",
    "curl",
    "vim",
    "libaio1",
    "net-tools",
    "build-essential",
    "openssh-server",
    "puppet",
  ]
  ) {

  exec { "system-apt-update":
    command => "apt update",
  }

  exec { "system-apt-upgrade":
    command => "apt --yes upgrade",
    require => Exec["system-apt-update"],
  }

  package { $packages:
    ensure => "installed",
    require => Exec["system-apt-update"],
  }

  package { "install-rng-tools":
    name => "rng-tools",
    ensure => "installed",
    require => Exec["system-apt-update"],
  }

  exec { "enable-urandom":
    command => "echo 'HRNGDEVICE=/dev/urandom' >> /etc/default/rng-tools",
    require => Package["install-rng-tools"],
  }

  exec { "start-rng-tool":
    command => "/etc/init.d/rng-tools start",
    require => Exec["enable-urandom"],
  }

  file { "create-desktop-entry-dir" :
    path => "/usr/local/share/applications",
    ensure => "directory",
  }
}