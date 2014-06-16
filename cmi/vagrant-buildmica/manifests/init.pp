### FIREWALL ##########
resources { "firewall":
  purge => true
}

$binpath = "/usr/local/bin/:/bin/:/usr/bin/:/usr/share/"

exec { "clone":
    command => "git clone https://github.com/thehyve/mica.git",
    cwd => "/vagrant",
    path    => $binpath,
    creates => '/vagrant/mica'
} ->
package {'drush':
  ensure => present
} ->
exec { "update drush":
  command => "drush dl drush --destination='/usr/share'",
  path    => $binpath
} ->
exec { "make":
  command => "make clean dev",
  cwd     => "/vagrant/mica",
  path    => $binpath,
}

#->
# import 'lamp.pp'
# import 'tomcat.pp'
