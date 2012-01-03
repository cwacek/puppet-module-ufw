class ufw {
  package { "ufw":
    ensure => present,
  }

  Package["ufw"] -> Exec["ufw-default-deny"] -> Exec["ufw-enable"]

  exec { "ufw-default-deny":
    command => "/usr/sbin/ufw default deny",
    unless => "/usr/sbin/ufw status verbose | grep \"[D]efault: deny (incoming), allow (outgoing)\"",
  }

  exec { "ufw-enable":
    command => "/usr/bin/yes | ufw enable",
    unless => "/usr/sbin/ufw status | grep \"[S]tatus: active\"",
  }

  service { "ufw":
    ensure => running,
    enable => true,
    hasstatus => true,
    subscribe => Package["ufw"],
  }
}
