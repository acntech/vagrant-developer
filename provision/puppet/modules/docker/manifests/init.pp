class docker (
  $docker_compose_version = "1.24.1"
  ) {

  exec { "docker-apt-key":
    command => "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
  }

  exec { "docker-apt-repo":
    command => "add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
    require => Exec["docker-apt-key"],
  }

  exec { "apt-update":
    command => "apt update",
    require => Exec["docker-apt-repo"],
  }

  package { "docker-install":
    name => "docker-ce",
    ensure => "installed",
    require => Exec["apt-update"],
  }

  user { "docker-group":
    name => "vagrant",
    groups => "docker",
    require => Package["docker-install"],
  }

  exec { "docker-compose-install":
    command => "curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose",
    unless => ["which docker-compose && docker-compose -v | grep -q \"version ${docker_compose_version}\""]
  }

  file { "docker-compose-set-executable":
    path => "/usr/local/bin/docker-compose",
    mode => "0755",
    require => Exec["docker-compose-install"]
  }
}
