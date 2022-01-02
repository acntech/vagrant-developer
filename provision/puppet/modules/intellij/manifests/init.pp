class intellij (
  $intellij_version = "2021.3.1", # Change this value to upgrade IntelliJ.
  $intellij_root = "/opt/intellij",
  $intellij_home = "/opt/intellij/default",
  ) {

  exec { "download-intellij" :
    command => "curl -L https://download.jetbrains.com/idea/ideaIU-${intellij_version}.tar.gz -o /tmp/intellij.tar.gz",
    unless => ["test -d ${intellij_root}/ideaIU-${intellij_version}"],
  }

  exec { "delete-intellij":
    command => "rm -rf ${intellij_root}",
    before => File["create-intellij-dir"],
  }

  file { "create-intellij-dir" :
    path => "${intellij_root}",
    ensure => "directory",
    before => Exec["extract-intellij"],
  }

  exec { "extract-intellij":
    command => "tar -xzvf /tmp/intellij.tar.gz --strip-components=1 -C ${intellij_root}/ideaIU-${intellij_version}",
    require => Exec["download-intellij"],
  }

  file { "add-intellij-symlink":
    path => "${intellij_home}",
    ensure => "link",
    target => "${intellij_root}/ideaIU-${intellij_version}",
    require => Exec["extract-intellij"],
  }

  file { "add-intellij-desktop-entry":
    path => "/usr/local/share/applications/intellij.desktop",
    source => "puppet:///modules/intellij/intellij.desktop",
  }

  exec { "cleanup-intellij":
    command => "rm /tmp/intellij.tar.gz",
    require => Exec["extract-intellij"],
  }
}