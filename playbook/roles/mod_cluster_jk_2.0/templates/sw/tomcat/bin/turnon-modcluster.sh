#!/bin/sh

for HTTPD_MAIN_HOST in "${HTTPD_MAIN_HOSTS[@]}"
do
    #echo $HTTPD_MAIN_HOST

    echo "<<< Turn-ON Worker $WORKER in [$HTTPD_MAIN_HOST]"
{% if httpd_main_hosts is defined and httpd_main_hosts is not none %}
    if [ "`curl --silent --show-error --connect-timeout 1 -I -k \"https://$HTTPD_MAIN_HOST/mod_cluster_manager?Cmd=ENABLE-APP&Range=NODE&JVMRoute=$WORKER\" | egrep '404|500|503'`" != "" ]
{% else %}
    if [ "`curl --silent --show-error --connect-timeout 1 -I -k \"http://$HTTPD_MAIN_HOST/mod_cluster_manager?Cmd=ENABLE-APP&Range=NODE&JVMRoute=$WORKER\" | egrep '404|500|503'`" != "" ]
{% endif %}
    then
        echo "<<< Error"
    else
        echo "<<< Done"
    fi
done

