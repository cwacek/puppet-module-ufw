define ufw::allow($proto="tcp", $port="all", $ip="", $from="any") {

  if $ipaddress_eth0 != undef {
    $ipadr = $ip ? {
      "" => $ipaddress_eth0,
      default => $ip,
    }
  } else {
    $ipadr = "any"
  }

  $from_match = $from ? {
    "any" => "Anywhere",
    default => "$from/$proto",
  }

  $matchstring = $port ? {
      "all" => "$ipadr/$proto",
      default => "$ipadr $port/$proto",
  }

  exec { "ufw-allow-${proto}-from-${from}-to-${ipadr}-port-${port}":
    command => $port ? {
      "all" => "/usr/sbin/ufw allow proto $proto from $from to $ipadr",
      default => "/usr/sbin/ufw allow proto $proto from $from to $ipadr port $port",
    },
    onlyif => "/usr/sbin/ufw status | /bin/grep -E \"$matchstring +ALLOW +from_match\"",
    require => Exec["ufw-default-deny"],
    before => Exec["ufw-enable"],
  }
}
