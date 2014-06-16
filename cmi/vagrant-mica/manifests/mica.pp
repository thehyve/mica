include wget


file { "/var/www/html/mica":
  ensure => directory,
  recurse => true,
  owner => "apache",
  group => "apache",
  #mode => 0755,
} 