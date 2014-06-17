exec { "symlink to modules":
  command => 'ln -s /sesimodules sesi',
  pwd     => '/var/www/html/mica/sites/all/modules',
  path    => "/usr/local/bin/:/bin/:/usr/bin/"
}




