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
package {'php-pdo':
  ensure => present,
} ->
package {'php-mysql':
  ensure => present,
} ->
package {'php-bcmath':
  ensure => present,
} ->
package {'php-pear':
  ensure => present,
} ->
set_php_var {
  "memory_limit":        value => '1024M';
  "max_execution_time":  value => '60';
  "extension":           value => 'pdo.so';
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


exec { "pear install Mail_Mime Mail_mimeDecode" :
  requires => Package['php-pear'],
}
