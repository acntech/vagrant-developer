class maven (
  $maven_version = "3.6.2", # Change this value to upgrade Maven.
  $maven_root = "/opt/maven",
  $maven_home = "/opt/maven/default",
  $tmp = "/tmp"
  ) {

  exec { "download-maven" :
    command => "wget --no-cookies --no-check-certificate https://www.apache.org/dist/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz -O ${tmp}/maven.tar.gz",
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
    command => "tar -xzvf ${tmp}/maven.tar.gz -C ${maven_root} && rm ${tmp}/maven.tar.gz",
    require => Exec["download-maven"],
  }

  file { "maven-symlink":
    path => "${maven_home}",
    ensure => "link",
    target => "${maven_root}/apache-maven-${maven_version}",
    require => Exec["extract-maven"],
  }

  exec { "set-default-maven":
    command => "update-alternatives --install \"/usr/bin/mvn\" \"mvn\" \"/opt/maven/default/bin/mvn\" 1 && update-alternatives --set \"mvn\" \"/opt/maven/default/bin/mvn\"",
    require => Exec["extract-maven"],
  }

  file { "/etc/profile.d/maven.sh":
    content => "export MAVEN_HOME=${maven_home}\nexport M2_HOME=\${MAVEN_HOME}\nexport PATH=\${PATH}:\$MAVEN_HOME/bin\n",
    require => Exec["extract-maven"],
  }
}