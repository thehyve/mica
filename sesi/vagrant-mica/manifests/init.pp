### FIREWALL ##########
resources { "firewall":
  purge => true
}


import 'lamp.pp'
import 'tomcat.pp'
import 'mica.pp'
import 'micadb.pp'
import 'devmodules.pp'
import 'xdebug.pp'
