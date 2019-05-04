#!/bin/sh

export LANG=ko_KR

PWD=`pwd`
HOSTNAME=`hostname`
HOME_DIR=`dirname $0`
BATAGENT_HOME=$PWD/$HOME_DIR
BATAGENT_LOG_HOME=$BATAGENT_HOME/log

# SYSTEM_ID: config를 읽을 때, DEV/STG/PRD인지 알 수 있는 인자값. PRD는 RNBA로 선언
{% if 'bpv-' in ansible_hostname %}
SYSTEM_ID=RNBA01
{% elif 'bsv-' in ansible_hostname %}
SYSTEM_ID=SNBA01
{% elif 'bdv-' in ansible_hostname %}
SYSTEM_ID=DNBA01
{% else %}
SYSTEM_ID=DNBA01
{% endif %}

# JAVA_HOME=

ENCRYPTION_KEY_FILE=

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
        JAVA="$JAVA_HOME/bin/java"
    else
        JAVA="java"
    fi
fi

CLASSPATH=$BATAGENT_HOME/config
for line in $BATAGENT_HOME/lib/*.jar
do
  CLASSPATH="$CLASSPATH:$line"
done
for line in $BATAGENT_HOME/lib/ext/*.jar
do
  CLASSPATH="$CLASSPATH:$line"
done
export CLASSPATH

# Setup the OUT LOG
OUT_LOG_FILE=$BATAGENT_LOG_HOME/out.log


