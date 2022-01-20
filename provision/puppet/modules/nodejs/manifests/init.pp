class nodejs (
  $nodejs_version = "node_17.x",
  ) {

  exec { "node-apt-key":
    command => "curl -fsSL \"https://deb.nodesource.com/gpgkey/nodesource.gpg.key\" | sudo apt-key add -",
    unless => ["dpkg -l nodejs > /dev/null 2>&1"],
  }

  exec { "yarn-apt-key":
    command => "curl -fsSL \"https://dl.yarnpkg.com/debian/pubkey.gpg\" | sudo apt-key add -",
    unless => ["dpkg -l yarn > /dev/null 2>&1"],
  }

  exec { "node-apt-repo":
    command => "add-apt-repository \"deb https://deb.nodesource.com/${nodejs_version} $(lsb_release -cs) main\"",
    subscribe => Exec["node-apt-key"],
    refreshonly => true,
  }

  exec { "yarn-apt-repo":
    command => "add-apt-repository \"deb https://dl.yarnpkg.com/debian stable main\"",
    subscribe => Exec["yarn-apt-key"],
    refreshonly => true,
  }

  exec { "node-apt-update":
    command => "apt update",
    require => Exec["node-apt-repo", "yarn-apt-repo"],
  }

  package { "node-install-nodejs":
    name => "nodejs",
    ensure => "installed",
    require => Exec["node-apt-update"],
  }

  package { "node-install-nodejs-legacy":
    name => "nodejs-legacy",
    ensure => "installed",
    require => Package["node-install-nodejs"],
  }

  package { "node-install-yarn":
    name => "yarn",
    ensure => "installed",
    require => Package["node-install-nodejs"],
  }
}
