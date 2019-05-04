#!/bin/sh

# Check WAS port ready
echo ""

{% if ajp_port is not none %}
echo "Check $AJP_PORT port ready on $BIND_ADDR"
while [ `netstat -an | grep :$AJP_PORT | grep LISTEN | wc | awk '{print $1}'` != 1 ]; do
    echo -ne "."
    sleep 1
done
{% elif http_port is not none %}
echo "Check $HTTP_PORT port ready on $BIND_ADDR"
while [ `netstat -an | grep :$HTTP_PORT | grep LISTEN | wc | awk '{print $1}'` != 1 ]; do
    echo -ne "."
    sleep 1
done
{% else %}
echo "Check default(8009) port ready on $BIND_ADDR"
while [ `netstat -an | grep :8009 | grep LISTEN | wc | awk '{print $1}'` != 1 ]; do
    echo -ne "."
    sleep 1
done
{% endif %}
echo ""

# Wait WAS context ready
{% if http_port is not defined or http_port is none %}
echo "Waiting WAS context ready"
for i in $(seq 1 30)
do
    echo -ne "."
    sleep 1
done
echo ""
{% else %}
echo "Check WAS Context Ready http://$BIND_ADDR:$HTTP_PORT$CONTEXT_NAME"
until [ "`curl --silent --show-error --connect-timeout 1 -I http://$BIND_ADDR:$HTTP_PORT$CONTEXT_NAME | egrep '200|302'`" != "" ];
do
    echo -ne "."
    sleep 1
done
echo ""
{% endif %}

