class system {

  $packages = [
    "libaio1"
  ]

  package { $packages:
    ensure => "installed",
  }

  package { "install-rng-tools":
    name => "rng-tools",
    ensure => "installed",
  }

  exec { "enable-urandom":
    command => "echo 'HRNGDEVICE=/dev/urandom' >> /etc/default/rng-tools",
    require => Package["install-rng-tools"],
  }

  exec { "start-rng-tool":
    command => "/etc/init.d/rng-tools start",
    require => Exec["enable-urandom"],
  }
}