
#
#exec { "wget ":
#  command => "wget ",
#  cwd     => "/tmp/mica",
#  path    => "/usr/local/bin/:/bin/:/usr/bin/",
#  timeout => 0
#}
$zipname = 'mica-distribution-7.x-9.1-b3211'
$internalname = 'mica_distribution-7.x-9.1-b3211'
$zipfile = "${zipname}.jar"
$wwwfolder = '/var/www/html'

exec { "wget from nexus if jar not exist":
  command => "wget http://185.9.174.106/cmicognizant/micabkp/obiba/mica-distribution-7.x-9.1-b3211.jar ",
  cwd     => "/rootinstall",
  creates => "/rootinstall/${zipfile}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "copy zip to www":
  command => "cp  -f ${zipfile} ${wwwfolder}",
  cwd     => "/rootinstall",
  creates => "${wwwfolder}/${zipfile}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
  require => Package['httpd'],
} ->
exec { "uncompress":
  command => "unzip  -o ${zipfile}",
  cwd     => "${wwwfolder}",
  creates => "${wwwfolder}/${zipname}",
  path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "rename":
  command => "cp -Rf ${wwwfolder}/${internalname} ${wwwfolder}/mica",
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