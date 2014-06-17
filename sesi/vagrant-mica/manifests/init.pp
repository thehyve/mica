### FIREWALL ##########
resources { "firewall":
  purge => true
}
$binpath = "/usr/local/bin/:/bin/:/usr/bin/"

import 'lamp.pp'
import 'tomcat.pp'
import 'mica.pp'
import 'micadb.pp'