
#
#exec { "wget ":
#  command => "wget ",
#  cwd     => "/tmp/mica",
#  path    => $binpath,
#  timeout => 0
#}

exec { "wget from nexus if tgz not exist":
  command => "wget ... ",
  cwd     => "/vagrant",
  creates => 'mica.tar.gz',
  path    => $binpath,
  timeout => 0
} ->
exec { "uncompress":
  command => "wget ",
  cwd     => "/vagrant",
  creates => 'mica.tar.gz',
  path    => $binpath,
  timeout => 0
} ->
file { "/var/www/html/mica":
  ensure => directory,
  recurse => true,
  owner => "apache",
  group => "apache",
  #mode => 0755,
} 