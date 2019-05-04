#!/bin/sh
# -------------------------------------------------------------
#   KHAN [provisioning]              http://www.opennaru.com/
#   JBoss EAP 6.4.0
#
#   contact : service@opennaru.com
#   Copyright(C) 2015, opennaru.com, All Rights Reserved.
# -------------------------------------------------------------

. ./env.sh 

if [ e$1 = "ewait" ]
then
    for HTTPD_MAIN_HOST in "${HTTPD_MAIN_HOSTS[@]}"
    do
        echo "<<< Turn-OFF Worker $WORKER in [$HTTPD_MAIN_HOST]"
        if [ "`curl --silent --show-error --connect-timeout 1 -I -k \"https://$HTTPD_MAIN_HOST/mod_cluster_manager?Cmd=STOP-APP&Range=NODE&JVMRoute=$WORKER\" | egrep '404|500|503'`" != "" ]
        then
            echo "<<< Error"
        else
            echo "<<< Done"
        fi
    done

    for HTTPD_HOST in "${HTTPD_HOSTS[@]}"
    do
        echo "<<< Turn-OFF mod_jk Worker $SERVER_NAME in $LB_WORKER [$HTTPD_HOST]"
        if [ "`curl --silent --show-error --connect-timeout 1 -I \"http://$HTTPD_HOST:$APACHE_PORT/jkstatus?cmd=update&w=$LB_WORKER&sw=$SERVER_NAME&vwa=2\" | egrep '404|500|503'`" != "" ]
        then
            echo "<<< Error"
        else
            echo "<<< Done"
        fi
    done
    sleep 3
fi

$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$CONTROLLER_IP:$CONTROLLER_PORT --command=:shutdown

if [ e$1 = "ewait" ]
then
    # ex) ./shutdown.sh wait
    I=0
    until [ "`ps -eaf | grep java | grep $SERVER_NAME`" == "" ];
    do
        if [ $I == 10 ]; then
            ps -ef | grep java | grep "$SERVER_NAME " | awk {'print "kill -9 " $2'} | sh -x
            break;
        fi

        let I=$I+1

        echo -ne "."
        sleep 1
    done
    echo ""
fi
