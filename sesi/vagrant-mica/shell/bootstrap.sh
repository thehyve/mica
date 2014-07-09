#!/bin/bash
# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR='/rootinstall'

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum
GIT=/usr/bin/git
APT_GET=/usr/bin/apt-get
YUM=/usr/bin/yum
if [ ! -x $GIT ]; then
    if [ -x $YUM ]; then
        yum -q -y install git-core
    elif [ -x $APT_GET ]; then
        apt-get -q -y install git-core
    else
        echo "No package installer available. You may need to install git manually."
    fi
fi
                  
cd $PUPPET_DIR/modules
git init
# git submodule add https://github.com/puppetlabs/puppetlabs-stdlib.git stdlib
# git submodule add https://github.com/example42/puppi.git puppi
git submodule add https://github.com/maestrodev/puppet-wget.git wget
git submodule add https://github.com/puppetlabs/puppetlabs-firewall.git firewall

# git submodule add https://github.com/puppetlabs/puppetlabs-mysql.git mysql
# git submodule add https://github.com/puppetlabs/puppetlabs-apache.git apache

echo 'Running puppet from shell'

# now we run puppet for lamp
puppet apply  -vv  --debug --modulepath=$PUPPET_DIR/modules/ $PUPPET_DIR/manifests/cleanfw.pp
puppet apply  -vv  --debug --modulepath=$PUPPET_DIR/modules/ $PUPPET_DIR/manifests/init.pp
#puppet apply --debug -vv  --modulepath=/rootinstall/modules/ /rootinstall/manifests/init.pp

