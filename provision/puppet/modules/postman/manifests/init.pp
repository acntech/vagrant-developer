class postman (
  $postman_version = "9.7.1", # Change this value to upgrade Postman.
  $postman_root = "/opt/postman",
  $postman_home = "/opt/postman/default",
  ) {

  exec { "download-postman" :
    command => "curl -L https://dl.pstmn.io/download/latest/linux64 -o /tmp/postman.tar.gz",
    unless => ["test -d ${postman_root}/postman-${postman_version}"],
  }

  exec { "delete-postman":
    command => "rm -rf ${postman_root}",
    before => File["create-postman-dir"],
  }

  file { "create-postman-dir" :
    path => "${postman_root}",
    ensure => "directory",
    before => Exec["extract-postman"],
  }

  exec { "extract-postman":
    command => "tar -xzvf /tmp/postman.tar.gz --strip-components=1 -C ${postman_root}/postman-${postman_version}",
    require => Exec["download-postman"],
  }

  file { "add-postman-symlink":
    path => "${postman_home}",
    ensure => "link",
    target => "${postman_root}/postman-${postman_version}",
    require => Exec["extract-postman"],
  }

  file { "add-postman-desktop-entry":
    path => "/usr/local/share/applications/postman.desktop",
    source => "puppet:///modules/postman/postman.desktop",
  }

  exec { "cleanup-postman":
    command => "rm /tmp/postman.tar.gz",
    require => Exec["extract-postman"],
  }
}