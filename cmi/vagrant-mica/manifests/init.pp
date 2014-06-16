### FIREWALL ##########
resources { "firewall":
  purge => true
}

import 'lamp.pp'
import 'tomcat.pp'
