#!/bin/bash

#Any command that fails will cause the entire script to fail and return an exit status 
set -e

MICA=/var/www/html/mica
SESIMODS=$MICA/sites/all
art_version=`date '+%Y%m%d%H%M'`

if [ -z "$1" ]; then
  echo "first param should be the gz in nexus repo";
  echo "please find the appropiate gz in https://repo.thehyve.nl at RELEASES repository org/obiba/mica/devdb";
  exit;
fi;

cd ${MICA}
curl $1 | gunzip > /tmp/devdb.sql
drush sql-drop --yes && `drush sql-connect` < /tmp/devdb.sql

