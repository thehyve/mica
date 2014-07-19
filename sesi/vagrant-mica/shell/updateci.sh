#!/bin/bash

#Any command that fails will cause the entire script to fail and return an exit status 
set -e

MICA=/var/www/html/mica
SESIMODS=$MICA/sites/all

#if [ ! -d $GITSRC ]; then
#  echo "Mica repo not found. Cloning!"
#  cd /opt
#  git clone https://github.com/thehyve/mica.git
#fi

cd $SESIMODS

if [ "`git pull`" = "Already up-to-date." ]; then
  echo "Nothing to do"
  exit 0
fi

#continue with CI defined processes
echo "Updated from repo and running drupalpull.sh"
bash drupalpull.sh

