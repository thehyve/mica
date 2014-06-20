exec { "symlink to modules":
  command => 'ln -s /sesimodules sesi',
  cwd     => '/var/www/html/mica/sites/all/modules',
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
  creates => '/var/www/html/mica/sites/all/modules/sesi',
  subscribe   => File["/var/www/html/mica"],
} ->
exec { "giving access to shared folder for apache user":
  command => 'usermod -a -G vboxsf apache',
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "changing sesimodules permissions":
  command => 'chmod -R a+rw /sesimodules',
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
}








