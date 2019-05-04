#!/bin/sh
if [ e$1 = "e" ]
then
  echo " [Error] argument missing : app dirname"
  echo " [Usage] ./jboss_app_restore.sh mas"
  
  exit;
fi

cd /apps/jboss
rm -rf $1
tar xvfp $1_1.tar
