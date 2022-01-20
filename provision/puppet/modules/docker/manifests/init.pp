class docker (
  $docker_compose_version = "1.24.1"
  ) {

  exec { "docker-apt-key":
    command => "curl -fsSL \"https://download.docker.com/linux/ubuntu/gpg\" | sudo apt-key add -",
    unless => ["dpkg -l docker-ce > /dev/null 2>&1"],
  }

  exec { "docker-apt-repo":
    command => "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
    require => Exec["docker-apt-key"],
    unless => ["dpkg -l docker-ce > /dev/null 2>&1"],
  }

  exec { "docker-apt-update":
    command => "apt update",
    subscribe => Exec["docker-apt-repo"],
    refreshonly => true,
  }

  package { "docker-io-uninstall":
    name => "docker.io",
    ensure => "absent",
    before => Package["docker-install"],
  }

  package { "docker-install":
    name => "docker-ce",
    ensure => "installed",
    require => Exec["docker-apt-update"],
  }

  user { "docker-group":
    name => "vagrant",
    groups => "docker",
    require => Package["docker-install"],
  }

  exec { "docker-compose-install":
    command => "curl -fsSL \"https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
    unless => ["which docker-compose > /dev/null 2>&1 && docker-compose -v | grep -q \"version ${docker_compose_version}\""],
  }

  file { "docker-compose-set-executable":
    path => "/usr/local/bin/docker-compose",
    mode => "0755",
    require => Exec["docker-compose-install"]
  }
}
