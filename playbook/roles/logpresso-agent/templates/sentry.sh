#!/bin/sh

# ENVIRONMENT VARIABLE CONFIGRATION
#######################################################################################################
PKGDIR="/sw/answer/sentry"
JAVA_HOME=/sw/answer/jdk1.7.0_80
ARAQNE_CORE_VERSION=3.2.1-5
MIN_HEAP_SIZE=512M
MAX_HEAP_SIZE=512M
LOGKEEPDAY=7

########################################################################################################
export MALLOC_ARENA_MAX=1
export JAVA_HOME
INSTANCE_ID="Araqne"
########################################################################################################
# MAYBE YOU DON'T NEED TO TOUCH BELOW HERE
########################################################################################################
# GENERAL CONFIGURATION

JAVA_OPTS="$JAVA_OPTS -DINSTANCE_ID=$INSTANCE_ID"
JAVA_OPTS="$JAVA_OPTS -Dipojo.proxy=disabled"
JAVA_OPTS="$JAVA_OPTS -Daraqne.ssh.timeout=0"
JAVA_OPTS="$JAVA_OPTS -Daraqne.ssh.address=127.0.0.1"
JAVA_OPTS="$JAVA_OPTS -Daraqne.log.keepdays=$LOGKEEPDAY"
JAVA_OPTS="$JAVA_OPTS -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=60 -XX:+PrintGCDetails"
JAVA_OPTS="$JAVA_OPTS -XX:-OmitStackTraceInFastThrow"
JAVA_OPTS="$JAVA_OPTS -Xms$MIN_HEAP_SIZE -Xmx$MAX_HEAP_SIZE"
JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDateStamps"
JAVA_OPTS="$JAVA_OPTS -Xloggc:$PKGDIR/log/gc.log"
JAVA_OPTS="$JAVA_OPTS -XX:+UseGCLogFileRotation"
JAVA_OPTS="$JAVA_OPTS -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=1024k"
########################################################################################################
# GENERAL RUN SCRIPT

PROC_PATTERN=`ps -ef|grep "java -DINSTANCE_ID=$INSTANCE_ID"|grep -v grep|awk '{print $2}'`


case $1 in
status)
        if [ -n "$PROC_PATTERN" ]; then
                echo Logpresso running
        else
                echo Logpresso not running
        fi
;;
stop)
        PID=$PROC_PATTERN
        if [ -z "$PID" ]; then
                echo Logpresso not running
                exit 0
        fi
        kill $PID 2>&1 > /dev/null
        echo -n "waiting for shutdown..."
        while [ -f "/proc/$PID" ]; do
                sleep 0.5
        done
        echo "done"

;;
start|*)
        # bash specific
#        shopt -u huponexit
#        ulimit -n 50240

        if [ -n "$PROC_PATTERN" ]; then
                echo "araqne-core with INSTANCE_ID=$INSTANCE_ID is already running in PID " $PROC_PATTERN
        else
                echo "starting araqne-core with INSTANCE_ID=$INSTANCE_ID.."
                cd $PKGDIR
                $JAVA_HOME/bin/java $JAVA_OPTS -jar araqne-core-$ARAQNE_CORE_VERSION-package.jar > /dev/null 2>&1 &
        fi
;;
esac
