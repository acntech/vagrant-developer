class java (
  $java_dir = "temurin-jdk-17.0.1",
  $java_root = "/opt/java",
  $java_home = "${java_root}/default",
  $java_install = "${java_root}/${java_dir}",
  ) {

  exec { "download-java":
    command => "curl -fsSL \"https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz\" -o /tmp/jdk.tar.gz",
    timeout => 1800,
    unless => ["test -d ${java_install}"],
  }

  file { ["${java_root}", "${java_install}"]:
    ensure => "directory",
    before => Exec["install-java"],
  }

  exec { "install-java":
    command => "tar -xzvf /tmp/jdk.tar.gz --strip-components=1 -C ${java_install}",
    subscribe => Exec["download-java"],
    refreshonly => true,
  }

  file { "java-symlink":
    path => "${java_home}",
    ensure => "link",
    target => "./${java_dir}",
    require => Exec["install-java"],
  }

  file { "add-java-env":
    path => "/etc/profile.d/java.sh",
    source => "puppet:///modules/java/java-profile.sh",
    replace => false,
  }

  exec { "cleanup-java":
    command => "rm /tmp/jdk.tar.gz",
    subscribe => Exec["install-java"],
    refreshonly => true,
  }
}
