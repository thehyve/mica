$wwwfolder = '/var/www/html'

exec { "rm ${wwwfolder}/mica/sites/all":
  command => "rm -Rf all",
  cwd     => "${wwwfolder}/mica/sites",
  creates => "${wwwfolder}/mica/sites/all/.git",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "git clone sesisite":
  command => "git clone https://github.com/thehyve/sesi_site.git all",
  cwd     => "${wwwfolder}/mica/sites",
  creates => "${wwwfolder}/mica/sites/all/.git",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "git pull just in case":
  command => "git pull",
  cwd     => "${wwwfolder}/mica/sites/all",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
file { "${wwwfolder}/mica/sites/all":
  ensure => directory,
  recurse => true,
  owner => "apache",
  group => "apache",
  #mode => 0755,
}
