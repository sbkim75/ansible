#!/bin/sh
# -------------------------------------------------------------
#   KHAN [provisioning]              http://www.opennaru.com/
#   JBoss EAP 6.4.0
#
#   contact : service@opennaru.com
#   Copyright(C) 2015, opennaru.com, All Rights Reserved.
# -------------------------------------------------------------

. ./setEnv.sh
. ./function.sh

DATE=`date +%Y%m%d_%H%M%S`

##### JBOSS Directory Setup #####
export JBOSS_HOME=/sw/jboss/jboss-eap-6.4
export DOMAIN_GROUP_NAME={{ domain_group_name  }}
export DOMAIN_BASE=/sw/jboss/domains
export SERVER_NAME={{ instance_nm }}
export JBOSS_LOG_DIR=/logs/jboss

export HTTPD_MAIN_HOSTS=( {{ httpd_main_hosts }} )
export HTTPD_HOSTS=( {{ httpd_hosts }} )
export LB_WORKER={{ lb_worker }}
export APACHE_PORT=8082

if [ e$JBOSS_LOG_DIR = "e" ]
then
export JBOSS_LOG_DIR="$JBOSS_HOME/log"
fi

if [ e$JBOSS_LOG_DIR != "e" ]
then
export JBOSS_LOG_DIR="$JBOSS_LOG_DIR/$SERVER_NAME"
fi


##### Configration File #####
export CONFIG_FILE=standalone-ha.xml

export HOST_NAME={{ ansible_hostname }}
export NODE_NAME=$SERVER_NAME

export PORT_OFFSET={{ port_offset }}


export JBOSS_USER=jboss

##### Bind Address #####

export BIND_ADDR={{ ansible_eth0.ipv4.address }}

export MULTICAST_ADDR={{ multicast_addr }}
export MULTICAST_PORT=55200
export JMS_MULTICAST_ADDR={{ jms_multicast_addr }}
export MODCLUSTER_MULTICAST_ADDR={{ modcluster_multicast_addr }}

export MGMT_ADDR={{ ansible_eth0.ipv4.address }}

export CONTROLLER_IP=$MGMT_ADDR
let CONTROLLER_PORT=9999+$PORT_OFFSET
export CONTROLLER_PORT

let CONSOLE_PORT=9990+$PORT_OFFSET
export CONSOLE_PORT

let HTTP_PORT=8080+$PORT_OFFSET
export HTTP_PORT

export LAUNCH_JBOSS_IN_BACKGROUND=true

##### JBoss System module and User module directory #####
export JBOSS_MODULEPATH=$JBOSS_HOME/modules

##### KHAN [agent] #####
export AGENT_OPTS=" -javaagent:$(getKhanAgentPath /sw/jboss/domains/khan-agent) "
#export AGENT_OPTS="$AGENT_OPTS -javaagent:/sw/jboss/domains/khan-agent/jamm-0.2.5.jar "
export AGENT_OPTS="$AGENT_OPTS -Dkhan.config.file=khan-agent-{{ instance_nm }}.conf"

export JAVA_OPTS="$JAVA_OPTS -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
#export JBOSS_LOGMANAGER_DIR="$JBOSS_HOME/modules/system/layers/base/org/jboss/logmanager/main"
#export JBOSS_LOGMANAGER_JAR=`cd "$JBOSS_LOGMANAGER_DIR" && ls -1 *.jar`
export JBOSS_LOGMANAGER_JAR=$(getLogmanagerPath "$JBOSS_HOME")
export JAVA_OPTS="$JAVA_OPTS -Xbootclasspath/p:$JBOSS_LOGMANAGER_DIR/$JBOSS_LOGMANAGER_JAR"

# JVM Options : Server
export JAVA_OPTS="-server $JAVA_OPTS"

# JVM Options : Memory
#export JAVA_OPTS=" $JAVA_OPTS -Xms2048m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=512m -Xss256k"
export JAVA_OPTS=" $JAVA_OPTS -Xms{{ java_xms }} -Xmx{{ java_xmx }} -Xss256k"

export JAVA_OPTS=" $JAVA_OPTS -noverify"
export JAVA_OPTS=" $JAVA_OPTS -XX:+PrintGCTimeStamps "
export JAVA_OPTS=" $JAVA_OPTS -XX:+PrintGCDetails "
export JAVA_OPTS=" $JAVA_OPTS -Xloggc:$JBOSS_LOG_DIR/gclog/gc_$DATE.log "

#export JAVA_OPTS=" $JAVA_OPTS -XX:+UseParallelGC "
#export JAVA_OPTS=" $JAVA_OPTS -XX:+UseParallelOldGC "

#export JAVA_OPTS=" $JAVA_OPTS -XX:+UseConcMarkSweepGC "
#export JAVA_OPTS=" $JAVA_OPTS -XX:+ExplicitGCInvokesConcurrent "
#export JAVA_OPTS=" $JAVA_OPTS -XX:+UseParNewGC "
#export JAVA_OPTS=" $JAVA_OPTS -XX:+CMSParallelRemarkEnabled "
#export JAVA_OPTS=" $JAVA_OPTS -XX:+UseCMSCompactAtFullCollection "

export JAVA_OPTS=" $JAVA_OPTS -XX:MaxMetaspaceSize=512m "
export JAVA_OPTS=" $JAVA_OPTS -XX:+UseG1GC "
export JAVA_OPTS=" $JAVA_OPTS -XX:MaxGCPauseMillis=200 "
export JAVA_OPTS=" $JAVA_OPTS -XX:G1ReservePercent=20 "
export JAVA_OPTS=" $JAVA_OPTS -XX:+DisableExplicitGC "
export JAVA_OPTS=" $JAVA_OPTS -XX:+UseStringDeduplication "
export JAVA_OPTS=" $JAVA_OPTS -XX:ParallelGCThreads=2 "

export JAVA_OPTS=" $JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError "
export JAVA_OPTS=" $JAVA_OPTS -XX:HeapDumpPath=$JBOSS_LOG_DIR/heapdump "


# Linux Large Page Setting
#export JAVA_OPTS=" $JAVA_OPTS  -XX:+UseLargePages "
#export JAVA_OPTS=" $JAVA_OPTS  -XX:LargePageSizeInBytes=2m "

#export JAVA_OPTS=" $JAVA_OPTS -verbose:gc"
export JAVA_OPTS=" $JAVA_OPTS -Djava.net.preferIPv4Stack=true"
export JAVA_OPTS=" $JAVA_OPTS -Dorg.jboss.resolver.warning=true"
export JAVA_OPTS=" $JAVA_OPTS -Dsun.rmi.dgc.client.gcInterval=0x7FFFFFFFFFFFFFFE"
export JAVA_OPTS=" $JAVA_OPTS -Dsun.rmi.dgc.server.gcInterval=0x7FFFFFFFFFFFFFFE"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.modules.system.pkgs=org.jboss.byteman,com.opennaru.khan.agent,org.github.jamm,org.jboss.logmanager"
export JAVA_OPTS=" $JAVA_OPTS -Djava.awt.headless=true"

#for darwin
export JBOSS_BASE_DIR="$DOMAIN_BASE_DIR"

export JAVA_OPTS=" $JAVA_OPTS -DDOMAIN_GROUP_NAME=$DOMAIN_GROUP_NAME "
export JAVA_OPTS=" $JAVA_OPTS -Djboss.server.base.dir=$DOMAIN_BASE/$SERVER_NAME"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.socket.binding.port-offset=$PORT_OFFSET"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.node.name=$NODE_NAME"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.bind.address.management=$MGMT_ADDR"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.bind.address=$BIND_ADDR"
export JAVA_OPTS=" $JAVA_OPTS -Djgroups.bind_addr=$BIND_ADDR"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.default.multicast.address=$MULTICAST_ADDR"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.messaging.group.address=$JMS_MULTICAST_ADDR"
export JAVA_OPTS=" $JAVA_OPTS -Djboss.modcluster.multicast.address=$MODCLUSTER_MULTICAST_ADDR"

export JAVA_OPTS=" $JAVA_OPTS -Dbalancer=balancer_{{ lb_worker }}"
export JAVA_OPTS=" $JAVA_OPTS -DbalancerGroup=G_{{ lb_worker }}"

export JAVA_OPTS=" $JAVA_OPTS -Djboss.server.log.dir=$JBOSS_LOG_DIR"

# jgroups stack
# udp, tcp, tcp-fileping, tcp-gossip
export JAVA_OPTS=" $JAVA_OPTS -Djboss.default.jgroups.stack=tcp "

export JAVA_OPTS=" $JAVA_OPTS -Djgroups.tcpping.initial_hosts={{ tcpping_initial_hosts }} "

export JAVA_OPTS=" $JAVA_OPTS -Djgroups.fileping.location=/share/data/fileping "

export JAVA_OPTS=" $JAVA_OPTS -Djgroups.tcpgossip.hosts={{ tcpgossip_hosts }} "

# external deployment directory
export JAVA_OPTS=" $JAVA_OPTS -Dexternal.deployment.dir={{ deployment_dir }} "

# Use log4j in application
export JAVA_OPTS=" $JAVA_OPTS -Dorg.jboss.as.logging.per-deployment=false "

# JAVA7 enableSNIExtension disable
#export JAVA_OPTS=" $JAVA_OPTS -Djsse.enableSNIExtension=false "

echo "============================================================="
echo "   KHAN [provisioning]              http://www.opennaru.com/ "
echo "   JBoss EAP 6.4.0                  service@opennaru.com"
echo "-------------------------------------------------------------"
echo "JBOSS_HOME=$JBOSS_HOME"
echo "DOMAIN_BASE=$DOMAIN_BASE"
echo "SERVER_NAME=$SERVER_NAME"
echo "CONFIG_FILE=$CONFIG_FILE"
echo "BIND_ADDR=$BIND_ADDR"
echo "PORT_OFFSET=$PORT_OFFSET"
echo "MULTICAST_ADDR=$MULTICAST_ADDR"
echo "CONTROLLER=$CONTROLLER_IP:$CONTROLLER_PORT"
echo "CONSOLE=http://$CONTROLLER_IP:$CONSOLE_PORT"
echo "SERVICE=http://$BIND_ADDR:$HTTP_PORT"
echo "============================================================="
