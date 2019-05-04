#!/bin/sh

for HTTPD_HOST in "${HTTPD_HOSTS[@]}"
do
    echo "<<< Turn-ON Worker $WORKER in $LB_WORKER [$HTTPD_HOST]"
    if [ "`curl --silent --show-error --connect-timeout 1 -I \"http://$HTTPD_HOST/jkstatus?cmd=update&w=$LB_WORKER&sw=$WORKER&vwa=0\" | egrep '404|500|503'`" != "" ]
    then
        echo "<<< Error"
    else
        echo "<<< Done"
    fi
done

