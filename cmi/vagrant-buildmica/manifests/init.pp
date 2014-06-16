### FIREWALL ##########
# resources { "firewall":
#   purge => true
# }

$nexususer = 'admin'
$nexuspasswd = '1234'

$binpath = "/usr/local/bin/:/bin/:/usr/bin/:/usr/share/"

# exec { "clone":
#     command => "git clone https://github.com/thehyve/mica.git",
#     cwd => "/vagrant",
#     path    => $binpath,
#     creates => '/vagrant/mica'
# } ->
package {'unzip':
  ensure => present
} ->
package {'drush':
  ensure => present
} ->
exec { "update drush":
  command => "drush dl drush --destination='/usr/share'",
  path    => $binpath
} ->
package {'node-less':
  ensure => present
} ->
package { "zip":
  ensure => present
#  require  => Exec['apt-get update'],
} ->
exec { "make":
  command => "make -d clean prod packonly",
  cwd     => "/mica",
  path    => $binpath,
  timeout => 0
} 

/*
see https://support.sonatype.com/entries/22189106-How-can-I-programatically-upload-an-artifact-into-Nexus-

curl -v -F r=releases -F hasPom=false -F e=jar -F g=com.test -F a=project -F v=1.0 -F p=jar -F file=@project-1.0.jar -u admin:admin123 http://localhost:8081/nexus/service/local/artifact/maven/content

For reference, here are all the available form parameters for this endpoint:

r - repository
hasPom - whether you are supplying the pom or you want one generated. If generated g, a, v, p, and c are not needed
e - extension
g - group id
a - artifact id
v - version
p - packaging
c - classifier (optional, not shown in examples above)
file - the file(s) to be uploaded. These need to come last, and if there is a pom file it should come before the artifact

exec { "nexus upload":
  command => "curl -v -F r=releases -F hasPom=false -F e=tgz -F g=${art_package} -F a=${art_name} -F v=${art_version} -F p=${} -F file=@project-1.0.jar -u ${nexususer}:${nexuspasswd} https://repo.thehyve.nl/nexus/service/local/artifact/maven/content",
  cwd     => "/mica",
  path    => $binpath,
  
} ->
*/
