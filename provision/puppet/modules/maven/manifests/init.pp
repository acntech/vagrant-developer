class maven (
  $maven_version = "3.8.4", # Change this value to upgrade Maven.
  $maven_root = "/opt/maven",
  $maven_home = "/opt/maven/default",
  ) {

  exec { "download-maven" :
    command => "curl -L https://www.apache.org/dist/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz -o /tmp/maven.tar.gz",
  }

  exec { "delete-maven":
    command => "rm -rf ${maven_root}",
    before => File["create-maven-dir"],
  }

  file { "create-maven-dir" :
    path => "${maven_root}",
    ensure => "directory",
    before => Exec["extract-maven"],
  }

  exec { "extract-maven":
    command => "tar -xzvf /tmp/maven.tar.gz -C ${maven_root}",
    require => Exec["download-maven"],
  }

  file { "add-maven-symlink":
    path => "${maven_home}",
    ensure => "link",
    target => "${maven_root}/apache-maven-${maven_version}",
    require => Exec["extract-maven"],
  }

  exec { "set-default-maven":
    command => "update-alternatives --install \"/usr/bin/mvn\" \"mvn\" \"/opt/maven/default/bin/mvn\" 1 && update-alternatives --set \"mvn\" \"/opt/maven/default/bin/mvn\"",
    require => Exec["extract-maven"],
  }

  file { "add-maven-env":
    path => "/etc/profile.d/maven.sh",
    source => "puppet:///modules/maven/maven-profile.sh",
  }

  exec { "cleanup-maven":
    command => "rm /tmp/maven.tar.gz",
    require => Exec["extract-maven"],
  }
}