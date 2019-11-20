class ant (
  $ant_version = "1.10.7", # Change this value to upgrade Ant.
  $ant_root = "/opt/ant",
  $ant_home = "/opt/ant/default",
  $tmp = "/tmp"
  ) {

  exec { "download-ant" :
    command => "wget --no-cookies --no-check-certificate https://www.apache.org/dist/ant/binaries/apache-ant-${ant_version}-bin.tar.gz -O ${tmp}/ant.tar.gz",
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
    command => "tar -xzvf ${tmp}/ant.tar.gz -C ${ant_root} && rm ${tmp}/ant.tar.gz",
    require => Exec["download-ant"],
  }

  file { "ant-symlink":
    path => "${ant_home}",
    ensure => "link",
    target => "${ant_root}/apache-ant-${ant_version}",
    require => Exec["extract-ant"],
  }

  file { "/etc/profile.d/ant.sh":
    content => "export ANT_HOME=${ant_home}\nexport PATH=\${PATH}:\$ANT_HOME/bin\n",
    require => Exec["extract-ant"],
  }
}