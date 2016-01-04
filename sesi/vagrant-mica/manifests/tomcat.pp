# ---------------------------------
# install tomcat and solr
# ---------------------------------
include wget

package {'tomcat6':
 ensure => 'present',
}

$soldir = "/rootinstall/solrinst"
$tomdir = "/usr/share/tomcat6"
$tgzfile = "/tmp/solr.tgz"
$solr_version = "solr-4.8.1"

wget::fetch { "download solr":
   source      => "https://archive.apache.org/dist/lucene/solr/4.8.1/${solr_version}.tgz",
   destination => "${tgzfile}",
   timeout     => 0,
   verbose     => false,
} ->
exec { "untar":
    command => "tar -xzvf ${tgzfile}  -C /tmp ",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "copywar":
    command => "cp /tmp/${solr_version}/dist/solr*.war ${tomdir}/webapps/solr.war",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
    require => Package['tomcat6'],
} ->
exec { "copy_lib":
    command => "cp ${soldir}/commons/* ${tomdir}/lib && cp ${soldir}/slf4j/* ${tomdir}/lib",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
file { "/home/solr":
    ensure => "directory",
} ->
exec { "copy_home":
    command => "unzip -o ${soldir}/example/base.zip -d /home/solr && chown -R tomcat /home/solr",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
} -> #unzip de war, to avoid restarting tomcat
file { "${tomdir}/webapps/solr":
    ensure => "directory",
} ->
exec { "unzip_war":
    command => "unzip -o ${tomdir}/webapps/solr.war -d ${tomdir}/webapps/solr",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
} ->
exec { "replace_webxml":
    command => "cp ${soldir}/web.xml ${tomdir}/webapps/solr/WEB-INF/web.xml",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
} -> 
service {'tomcat6':
  ensure => running,
  enable => true,
  require => Package['tomcat6'],
}



# exec { "copy_solr":
#     command => "cp /rootinstall/solr/solr.war /usr/share/tomcat6/webapps/solr.war",
#     path    => "/usr/local/bin/:/bin/",
# 	creates => "/usr/share/tomcat6/webapps/solr.war"
# }




# service {'tomcat6':
#   ensure => running,
#   enable => true,
#   hasrestart => true,
#   require => Package['tomcat6'],
# }
