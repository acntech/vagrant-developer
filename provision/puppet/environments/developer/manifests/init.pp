Exec {
    path => [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ]
}

class apt {

  exec { "apt-update":
    command => "apt update"
  }

  exec { "apt-upgrade":
    command => "apt --yes upgrade"
  }

  # Ensure apt is setup before running apt update
  Apt::Key <| |> -> Exec["apt-update"]
  Apt::Source <| |> -> Exec["apt-update"]

  # Ensure apt-get update has been run before installing any packages
  Exec["apt-update"] -> Package <| |>
}

include welcome
include system
include git
include docker
include java
include maven
include ant
include nodejs
