class vscode (
  $vscode_version = "1.63.2", # Change this value to upgrade Visual Studio Code.
  $vscode_root = "/opt/vscode",
  $vscode_home = "/opt/vscode/default",
  ) {

  exec { "download-vscode" :
    command => "curl -L https://code.visualstudio.com/sha/download?build=stable&os=linux-x64 -o /tmp/vscode.tar.gz",
    unless => ["test -d ${vscode_root}/vscode-${vscode_version}"],
  }

  exec { "delete-vscode":
    command => "rm -rf ${vscode_root}",
    before => File["create-vscode-dir"],
  }

  file { "create-vscode-dir" :
    path => "${vscode_root}",
    ensure => "directory",
    before => Exec["extract-vscode"],
  }

  exec { "extract-vscode":
    command => "tar -xzvf /tmp/vscode.tar.gz --strip-components=1 -C ${vscode_root}/vscode-${vscode_version}",
    require => Exec["download-vscode"],
  }

  file { "add-vscode-symlink":
    path => "${vscode_home}",
    ensure => "link",
    target => "${vscode_root}/vscode-${vscode_version}",
    require => Exec["extract-vscode"],
  }

  file { "add-vscode-desktop-entry":
    path => "/usr/local/share/applications/vscode.desktop",
    source => "puppet:///modules/vscode/vscode.desktop",
  }

  exec { "cleanup-vscode":
    command => "rm /tmp/vscode.tar.gz",
    require => Exec["extract-vscode"],
  }
}