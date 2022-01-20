class maven (
  $maven_version = "3.8.4", # Change this value to upgrade Maven.
  $maven_dir = "apache-maven-${maven_version}",
  $maven_root = "/opt/maven",
  $maven_home = "${maven_root}/default",
  $maven_install = "${maven_root}/${maven_dir}",
  ) {

  exec { "download-maven" :
    command => "curl -fsSL \"https://www.apache.org/dist/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz\" -o /tmp/maven.tar.gz",
    unless => ["test -d ${maven_install}"],
  }

  file { "create-maven-dir" :
    path => "${maven_root}",
    ensure => "directory",
    before => Exec["extract-maven"],
  }

  exec { "extract-maven":
    command => "tar -xzvf /tmp/maven.tar.gz -C ${maven_root}",
    subscribe => Exec["download-maven"],
    refreshonly => true,
  }

  file { "add-maven-symlink":
    path => "${maven_home}",
    ensure => "link",
    target => "./${maven_dir}",
    require => Exec["extract-maven"],
  }

  file { "add-maven-env":
    path => "/etc/profile.d/maven.sh",
    source => "puppet:///modules/maven/maven-profile.sh",
    replace => false,
  }

  exec { "cleanup-maven":
    command => "rm /tmp/maven.tar.gz",
    subscribe => Exec["extract-maven"],
    refreshonly => true,
  }
}
