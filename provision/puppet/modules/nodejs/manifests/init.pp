class nodejs (
  $nodejs_version = "node_12.x",
  ) {

  exec { "node-apt-key":
    command => "curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -",
  }

  exec { "yarn-apt-key":
    command => "curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -",
  }

  exec { "node-apt-repo":
    command => "add-apt-repository \"deb https://deb.nodesource.com/${nodejs_version} $(lsb_release -cs) main\"",
    require => Exec["node-apt-key"],
  }

  #exec { "node-apt-src-repo":
  #  command => "add-apt-repository \"deb-src https://deb.nodesource.com/${nodejs_version} $(lsb_release -cs) main\"",
  #  require => Exec["node-apt-repo"],
  #}

  exec { "yarn-apt-repo":
    command => "add-apt-repository \"deb https://dl.yarnpkg.com/debian stable main\"",
    require => Exec["yarn-apt-key"],
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