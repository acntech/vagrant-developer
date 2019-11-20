class welcome {

  exec { "print-welcome":
    command => "/etc/init.d/rng-tools start",
  }
}