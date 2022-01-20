class ant (
  $ant_version = "1.10.12", # Change this value to upgrade Ant.
  $ant_dir = "apache-ant-${ant_version}",
  $ant_root = "/opt/ant",
  $ant_home = "${ant_root}/default",
  $ant_install = "${ant_root}/${ant_dir}",
  ) {

  exec { "download-ant" :
    command => "curl -fsSL \"https://www.apache.org/dist/ant/binaries/apache-ant-${ant_version}-bin.tar.gz\" -o /tmp/ant.tar.gz",
    unless => ["test -d ${ant_install}"],
  }

  file { "create-ant-dir" :
    path => "${ant_root}",
    ensure => "directory",
    before => Exec["extract-ant"],
  }

  exec { "extract-ant":
    command => "tar -xzvf /tmp/ant.tar.gz -C ${ant_root}",
    subscribe => Exec["download-ant"],
    refreshonly => true,
  }

  file { "add-ant-symlink":
    path => "${ant_home}",
    ensure => "link",
    target => "./${ant_dir}",
    require => Exec["extract-ant"],
  }

  file { "add-ant-env":
    path => "/etc/profile.d/ant.sh",
    source => "puppet:///modules/ant/ant-profile.sh",
    replace => false,
  }

  exec { "cleanup-ant":
    command => "rm /tmp/ant.tar.gz",
    subscribe => Exec["extract-ant"],
    refreshonly => true,
  }
}
