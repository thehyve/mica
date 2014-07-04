package {'php-devel':
  ensure => present,
} ->
package {'gcc':
  ensure => present,
} ->
package {'gcc-c++':
  ensure => present,
} ->
package {'autoconf':
  ensure => present,
} ->
package {'automake':
  ensure => present,
} ->
exec { "pecl xdebug":
    command => "pecl install -s xdebug",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
    require => Package['php-pear'],
} ->
file { '/etc/php.d/xdebug.ini':
    ensure => present,
    source => "/rootinstall/xdebug/xdebug.ini",
} ->
exec { "touch php.ini to restart service":
    command => "touch /etc/php.ini",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
#    require => File['/etc/php.ini']
}
