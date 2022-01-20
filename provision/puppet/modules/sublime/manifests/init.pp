class sublime (
  ) {

  exec { "sublime-apt-key":
    command => "curl -fsSL \"https://download.sublimetext.com/sublimehq-pub.gpg\" | sudo apt-key add -",
    unless => ["dpkg -l sublime-text > /dev/null 2>&1"],
  }

  exec { "sublime-apt-repo":
    command => "add-apt-repository \"deb https://download.sublimetext.com/ apt/stable/\"",
    require => Exec["sublime-apt-key"],
    unless => ["dpkg -l sublime-text > /dev/null 2>&1"],
  }

  exec { "sublime-apt-update":
    command => "apt update",
    require => Exec["sublime-apt-repo"],
  }

  package { "sublime-apt-install":
    name => "sublime-text",
    ensure => "installed",
    require => Exec["sublime-apt-update"],
  }
}
