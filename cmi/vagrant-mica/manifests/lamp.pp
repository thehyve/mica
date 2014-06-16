### LAMP ###
#
define set_php_var($value) {
  exec { "sed -i 's/^;*[[:space:]]*$name[[:space:]]*=.*$/$name = $value/g' /etc/php.ini":
    unless  => "grep -xqe '$name[[:space:]]*=[[:space:]]*$value' -- /etc/php.ini",
    path    => "/bin:/usr/bin",
    require => Package[php],
    notify  => Service[httpd];
  }
}

notify {"initiating LAMP installation" :}

package {'php':
  ensure => present,
  before => File['/etc/php.ini'],
} ->
package {'php-mbstring':
  ensure => present,
} ->
package {'php-gd':
  ensure => present,
} ->
package {'php-xml':
  ensure => present,
} ->
file {'/etc/php.ini':
  ensure => file,
} ->
set_php_var {
  "memory_limit":        value => '1024M';
  "max_execution_time":  value => '60';
}

notify {"initiating apache installation" :
} ->
package {'httpd':
  ensure => present,
} ->
service {'httpd':
  ensure => running,
  enable => true,
  require => Package['httpd'],
  subscribe => File['/etc/php.ini'],
}

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

