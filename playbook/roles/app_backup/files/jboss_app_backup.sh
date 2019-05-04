#!/bin/sh
if [ e$1 = "e" ]
then
  echo " [Error] argument missing : app dirname"
  echo " [Usage] ./jboss_app_backup.sh mas"
  
  exit;
fi

cd /apps/jboss

for idx in {6..1}
do
  mv $1_$idx.tar $1_$((idx+1)).tar
done

tar cvfp $1_1.tar $1