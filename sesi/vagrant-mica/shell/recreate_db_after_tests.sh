#!/bin/bash

#Any command that fails will cause the entire script to fail and return an exit status 
set -e

BAMBOO_SERVER=https://ci.ctmmtrait.nl
BAMBOO_PLAN=OC-MIC
MICA=/var/www/html/mica
SESIMODS=$MICA/sites/all

cd $SESIMODS

SHD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

$SHD/is_there_new_build.py $BAMBOO_SERVER $BAMBOO_PLAN \
&& drush sql-drop --yes \
; `drush sql-connect` < $1

exit 0