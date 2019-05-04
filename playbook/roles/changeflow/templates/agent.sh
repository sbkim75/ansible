#!/bin/sh

#LANG=#USER_LANG#
LANG=ko_KR.utf8
export LANG

JAVA_HOME={{ java_home }}
export JAVA_HOME

PATH=$JAVA_HOME/bin:$PATH
export PATH
echo "PATH : " $PATH

AGENT_INSTALL_DIR={{ install_dir }}/CFAgent
export AGENT_INSTALL_DIR

CF_ENC=UTF-8
export CF_ENC

RUN_FLAG="-DCFAgent -Dcm.enc=$CF_ENC -Dagent.jar=$AGENT_INSTALL_DIR/agent/ChangeFlow.jar -Dagent.install.dir=$AGENT_INSTALL_DIR"
export RUN_FLAG

RUN_CLASS=com.gtone.cf.daemon.agent.DeploymentAgent
export RUN_CLASS

PROPERTY_FILE=/agent.properties
export PROPERTY_FILE

CLASSPATH=$AGENT_INSTALL_DIR/agent
CLASSPATH=$CLASSPATH:$AGENT_INSTALL_DIR/agent/log4j-1.2.8.jar
CLASSPATH=$CLASSPATH:$AGENT_INSTALL_DIR/agent/jSpeed.jar
CLASSPATH=$CLASSPATH:$AGENT_INSTALL_DIR/agent/ChangeFlow.jar
CLASSPATH=$CLASSPATH:$AGENT_INSTALL_DIR/agent/jt400.jar
export CLASSPATH

SERVICE_NAME="CFAgent"
cd $AGENT_INSTALL_DIR/agent
#umask 001
java -Xms256m -Xmx256m $RUN_FLAG $RUN_CLASS $PROPERTY_FILE
