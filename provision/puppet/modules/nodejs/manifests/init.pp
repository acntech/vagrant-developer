class nodejs (
  $nodejs_main_version = "12"
  $packages = [
    "nodejs",
    "nodejs-legacy",
    "npm",
    "yarn",
  ]
  ) {

  exec { "node-apt-key":
    command => "curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -",
  }

  exec { "yarn-apt-key":
    command => "curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -",
  }

  exec { "node-apt-repo":
    command => "add-apt-repository \"deb https://deb.nodesource.com/node_${nodejs_main_version}.x $(lsb_release -cs) main\"",
    require => Exec["node-apt-key"],
  }

  exec { "node-apt-src-repo":
    command => "add-apt-repository \"deb-src https://deb.nodesource.com/node_${nodejs_main_version}.x $(lsb_release -cs) main\"",
    require => Exec["node-apt-key"],
  }

  exec { "yarn-apt-repo":
    command => "add-apt-repository \"deb https://dl.yarnpkg.com/debian stable main\"",
    require => Exec["yarn-apt-key"],
  }

  exec { "apt-update":
    command => "apt update",
    require => Exec["node-apt-repo", "yarn-apt-repo"],
  }

  package { $packages:
    ensure => "installed",
    require => Exec["apt-update"],
  }
}