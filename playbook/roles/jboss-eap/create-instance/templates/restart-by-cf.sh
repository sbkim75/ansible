#!/bin/sh

. ~/.bashrc

cd /sw/jboss/domains/{{ instance_nm }}

echo "##########################################################"
echo "# start shutdown!!                                     #"
echo "##########################################################"
sudo systemctl stop jboss-{{ instance_nm }}

sleep 2

echo "##########################################################"
echo "# start startup!!                                      #"
echo "##########################################################"
sudo systemctl start jboss-{{ instance_nm }}
