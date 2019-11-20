class git {

  package { "install-git":
    name => "git",
    ensure => "installed",
  }

  package { "install-git-flow":
    name => "git-flow",
    ensure => "installed",
    require => Exec["install-git"],
  }

  file { "add-git-config":
    path => "/home/vagrant/.gitconfig",
    source => "../resources/gitconfig",
    owner => "vagrant",
    group => "vagrant",
  }
}
