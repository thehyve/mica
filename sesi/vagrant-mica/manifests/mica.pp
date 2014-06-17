
#
#exec { "wget ":
#  command => "wget ",
#  cwd     => "/tmp/mica",
#  path    => "/usr/local/bin/:/bin/:/usr/bin/",
#  timeout => 0
#}
$zipname = 'mica_distribution-7.x-9.1-b3211'
$zipfile = "${zipname}.zip"
$wwwfolder = '/var/www/html'

exec { "wget from nexus if tgz not exist":
  command => "wget ... ",
  cwd     => "/vagrant",
  creates => "/vagrant/${zipfile}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->

exec { "copy zip to www":
  command => "cp  -f ${zipfile} ${wwwfolder}",
  cwd     => "/vagrant",
  creates => "${wwwfolder}/${zipfile}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "uncompress":
  command => "unzip  ${zipfile}",
  cwd     => "${wwwfolder}",
  creates => "${wwwfolder}/${zipname}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "rename":
  command => "mv ${wwwfolder}/${zipname} ${wwwfolder}/mica",
  cwd     => "${wwwfolder}",
  creates => "${wwwfolder}/mica",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
file { "${wwwfolder}/mica":
  ensure => directory,
  recurse => true,
  owner => "apache",
  group => "apache",
  #mode => 0755,
} 