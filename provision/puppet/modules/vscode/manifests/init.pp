class vscode (
  $vscode_version = "1.63.2", # Change this value to upgrade Visual Studio Code.
  $vscode_dir = "vscode-${vscode_version}",
  $vscode_root = "/opt/vscode",
  $vscode_home = "${vscode_root}/default",
  $vscode_install = "${vscode_root}/${vscode_dir}",
  ) {

  exec { "download-vscode" :
    command => "curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=linux-x64 -o /tmp/vscode.tar.gz",
    unless => ["test -d ${vscode_install}"],
  }

  file { ["${vscode_root}", "${vscode_install}"] :
    ensure => "directory",
    before => Exec["install-vscode"],
  }

  exec { "install-vscode":
    command => "tar -xzvf /tmp/vscode.tar.gz --strip-components=1 -C ${vscode_install}",
    subscribe => Exec["download-vscode"],
    refreshonly => true,
  }

  file { "add-vscode-symlink":
    path => "${vscode_home}",
    ensure => "link",
    target => "./${vscode_dir}",
    require => Exec["install-vscode"],
  }

  file { "add-vscode-desktop-entry":
    path => "/usr/local/share/applications/vscode.desktop",
    source => "puppet:///modules/vscode/vscode.desktop",
    replace => false,
  }

  exec { "cleanup-vscode":
    command => "rm /tmp/vscode.tar.gz",
    subscribe => Exec["install-vscode"],
    refreshonly => true,
  }
}
