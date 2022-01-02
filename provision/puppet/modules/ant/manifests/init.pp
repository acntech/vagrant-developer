class ant (
  $ant_version = "1.10.12", # Change this value to upgrade Ant.
  $ant_root = "/opt/ant",
  $ant_home = "/opt/ant/default",
  ) {

  exec { "download-ant" :
    command => "curl -L https://www.apache.org/dist/ant/binaries/apache-ant-${ant_version}-bin.tar.gz -o /tmp/ant.tar.gz",
  }

  exec { "delete-ant":
    command => "rm -rf ${ant_root}",
    before => File["create-ant-dir"],
  }

  file { "create-ant-dir" :
    path => "${ant_root}",
    ensure => "directory",
    before => Exec["extract-ant"],
  }

  exec { "extract-ant":
    command => "tar -xzvf /tmp/ant.tar.gz -C ${ant_root}",
    require => Exec["download-ant"],
  }

  file { "add-ant-symlink":
    path => "${ant_home}",
    ensure => "link",
    target => "${ant_root}/apache-ant-${ant_version}",
    require => Exec["extract-ant"],
  }

  file { "add-ant-env":
    path => "/etc/profile.d/ant.sh",
    source => "puppet:///modules/ant/ant-profile.sh",
  }

  exec { "cleanup-ant":
    command => "rm /tmp/ant.tar.gz",
    require => Exec["extract-ant"],
  }
}