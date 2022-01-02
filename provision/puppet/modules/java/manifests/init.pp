class java (
  $java_root = "/opt/java",
  $java_home = "/opt/java/default",
  $java_install = "/opt/java/temurin-jdk-17.0.1",
  ) {

  exec { "download-java":
    command => "curl https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz -o /tmp/jdk.tar.gz",
    timeout => 1800,
    unless => ["test -d ${java_install}"],
  }

  file { "create-java-dir":
    path => "${java_root}",
    ensure => "directory",
    before => Exec["install-java"],
  }

  exec { "install-java":
    command => "tar -xzvf /tmp/jdk.tar.gz -C ${java_root}/ && rm -f /tmp/jdk.tar.gz",
    require => Exec["download-java"],
  }

  file { "java-symlink":
    path => "${java_home}",
    ensure => "link",
    target => "${java_install}",
    require => Exec["install-java"],
  }

  exec { "set-default-java":
    command => "update-alternatives --install \"/usr/bin/java\" \"java\" \"/opt/java/default/bin/java\" 1 && update-alternatives --set \"java\" \"/opt/java/default/bin/java\"",
    require => Exec["install-java"],
  }

  exec { "set-default-javac":
    command => "update-alternatives --install \"/usr/bin/javac\" \"javac\" \"/opt/java/default/bin/javac\" 1 && update-alternatives --set \"javac\" \"/opt/java/default/bin/javac\"",
    require => Exec["install-java"],
  }

  exec { "set-default-jar":
    command => "update-alternatives --install \"/usr/bin/jar\" \"jar\" \"/opt/java/default/bin/jar\" 1 && update-alternatives --set \"jar\" \"/opt/java/default/bin/jar\"",
    require => Exec["install-java"],
  }

  file { "add-java-env":
    path => "/etc/profile.d/java.sh",
    source => "puppet:///modules/java/java-profile.sh",
  }
}
