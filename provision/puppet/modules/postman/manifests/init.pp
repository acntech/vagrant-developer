class postman (
  $postman_version = "9.7.1", # Change this value to upgrade Postman.
  $postman_dir = "postman-${postman_version}",
  $postman_root = "/opt/postman",
  $postman_home = "${postman_root}/default",
  $postman_install = "${postman_root}/${postman_dir}",
  ) {

  exec { "download-postman" :
    command => "curl -fsSL \"https://dl.pstmn.io/download/latest/linux64\" -o /tmp/postman.tar.gz",
    unless => ["test -d ${postman_root}/postman-${postman_version}"],
  }

  file { ["${postman_root}", "${postman_install}"] :
    ensure => "directory",
    before => Exec["install-postman"],
  }

  exec { "install-postman":
    command => "tar -xzvf /tmp/postman.tar.gz --strip-components=1 -C ${postman_install}",
    require => Exec["download-postman"],
  }

  file { "add-postman-symlink":
    path => "${postman_home}",
    ensure => "link",
    target => "./${postman_dir}",
    require => Exec["install-postman"],
  }

  file { "add-postman-desktop-entry":
    path => "/usr/local/share/applications/postman.desktop",
    source => "puppet:///modules/postman/postman.desktop",
    replace => false,
  }

  exec { "cleanup-postman":
    command => "rm /tmp/postman.tar.gz",
    require => Exec["install-postman"],
  }
}
