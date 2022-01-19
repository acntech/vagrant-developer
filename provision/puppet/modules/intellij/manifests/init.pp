class intellij (
  $intellij_version = "2021.3.1", # Change this value to upgrade IntelliJ.
  $intellij_dir = "ideaIU-${intellij_version}",
  $intellij_root = "/opt/intellij",
  $intellij_home = "${intellij_root}/default",
  $intellij_install = "${intellij_root}/${intellij_dir}",
  ) {

  exec { "download-intellij" :
    command => "curl -fsSL https://download.jetbrains.com/idea/ideaIU-${intellij_version}.tar.gz -o /tmp/intellij.tar.gz",
    unless => ["test -d ${intellij_install}"],
  }

  file { ["${intellij_root}", "${intellij_install}"] :
    ensure => "directory",
    before => Exec["install-intellij"],
  }

  exec { "install-intellij":
    command => "tar -xzvf /tmp/intellij.tar.gz --strip-components=1 -C ${intellij_install}",
    subscribe => Exec["download-intellij"],
    refreshonly => true,
  }

  file { "add-intellij-symlink":
    path => "${intellij_home}",
    ensure => "link",
    target => "./${intellij_dir}",
    require => Exec["install-intellij"],
  }

  file { "add-intellij-desktop-entry":
    path => "/usr/local/share/applications/intellij.desktop",
    source => "puppet:///modules/intellij/intellij.desktop",
    replace => false,
  }

  exec { "cleanup-intellij":
    command => "rm /tmp/intellij.tar.gz",
    subscribe => Exec["install-intellij"],
    refreshonly => true,
  }
}
