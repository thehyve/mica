#!/bin/bash

#Any command that fails will cause the entire script to fail and return an exit status 
set -e

GITSRC=/opt/mica
MICA=/var/www/html/mica
SESIMODS=$MICA/sites/all/modules/sesi
DRUSHDIR=/opt/drush
COMPOSER=/usr/bin/composer

if [ ! -d $GITSRC ]; then
  echo "Mica repo not found. Cloning!"
  cd /opt
  git clone https://github.com/thehyve/mica.git
fi

cd $GITSRC

if [ "`git pull`" = "Already up-to-date." ]; then
  echo "Nothing to do"
#TODOOOOOOOOOOOOOOOOOO
#  exit 0
fi

#copying files from updated repo
if [ ! -d $SESIMODS ]; then
  mkdir $SESIMODS
fi

#continue with CI defined processes
echo "Updated from repo"

#trying to install composer drush
if [ ! -f $COMPOSER ]; then
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar $COMPOSER
fi

if [ ! -d $DRUSHDIR ]; then
  echo "Drush not found. Cloning!"
  cd /opt
  git clone https://github.com/drush-ops/drush.git
  cd /opt/drush
  composer install
  chmod a+x drush
  cd /usr/bin
  ln -s /opt/drush/drush 
fi

echo rsync -a --delete $GITSRC/sesi/modules $SESIMODS
cd $MICA
drush updatedb
drush features-revert-all
