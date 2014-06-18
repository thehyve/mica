exec { "symlink to modules":
  command => 'ln -s /sesimodules sesi',
  cwd     => '/var/www/html/mica/sites/all/modules',
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
  creates => '/var/www/html/mica/sites/all/modules/sesi',
  subscribe   => File["/var/www/html/mica"],
}




