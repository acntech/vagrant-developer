Exec {
    path => [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ]
}

include system
include git
include docker
include java
include maven
include ant
include nodejs
