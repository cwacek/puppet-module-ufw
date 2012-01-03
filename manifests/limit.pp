define ufw::limit($proto="tcp") {
  exec { "/usr/sbin/ufw limit $name/$proto":
    unless => "/usr/sbin/ufw status | grep -E \"^$name/$proto +LIMIT +Anywhere\"",
    require => Exec["ufw-default-deny"],
    before => Exec["ufw-enable"],
  }
}
