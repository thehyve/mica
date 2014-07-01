### LAMP ###
#

notify {"initiating mysql installation" :
} ->
  package {'mysql-server':
  ensure => 'present',
} ->
service {'mysqld':
  ensure => running,
  enable => true,
  require => Package['mysql-server'],
} ->
notify {"LAMP installed." :
}

