### LAMP ###
#
notify {"initiating LAMP installation" :}

package {'php':
 ensure => present,
 before => File['/etc/php.ini'],
}

file {'/etc/php.ini':
ensure => file,
}
notify {"initiating apache installation" :}

package {'httpd':
ensure => present,
}
service {'httpd':
ensure => running,
enable => true,
require => Package['httpd'],
subscribe => File['/etc/php.ini'],
}

notify {"initiating mysql installation" :}
package {'mysql-server':
 ensure => 'present',
}
service {'mysqld':
 ensure => running,
 enable => true,
 require => Package['mysql-server'],
}

notify {"LAMP installed." :}

