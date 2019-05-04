# @(#)B.11.31_LR     

# Default user .profile file (/usr/bin/sh initialization).

# Set up the terminal:
	if [ "$TERM" = "" ]
	then
		eval ` tset -s -Q -m ':?hp' `
	else
		eval ` tset -s -Q `
	fi
	stty erase "^H" kill "^U" intr "^C" eof "^D"
	stty hupcl ixon ixoff
	#tabs

# NOTE: '.' is added to $PATH for compatibility reasons only. This
#       default will be changed in a future release. If "." is not
#       needed for compatibility it is better to omit this line. 
#	Please edit .profile according to your site requirements.

# Set up the search paths:
#	PATH=.:~/bin:/home/cruzlink/setup

# Set up the shell environment:
	set -u
	trap "echo 'logout'" 0

# Set up the shell variables:
	#EDITOR=/usr/bin/vi
	EDITOR=vi
	export EDITOR

#cd /cruzlink

export PS1=[1m[31m$LOGNAME@`hostname`:'$PWD'][0m 

#default
alias rm='rm -i'
alias swdpt='cd /shcsw/swdpt/$LOGNAME'
alias swlog='cd /shcsw/swlog/$LOGNAME'

echo "****************************************************************"
#banner " FEP 1P"
echo "****************************************************************"
#export PS1="[1m[31m`hostname`:$PWD>[0m
## "
export HISTFILE=~/.sh_history
export HISTSIZE=20000
#export LANG=ko_KR.eucKR
export LANG=ko_KR.UTF-8

export JAVA_HOME=/usr/java/latest
export PATH=.:$JAVA_HOME/bin:/usr/local/bin:/usr/sbin:/usr/bin:/bin

# glance
# export PATH=$PATH:/opt/perf/bin

#======================================================================
#  Init Setting ENV
#======================================================================
##### Root Setting ######
export SOL_TYPE=FEP
#export SOL_TYPE=FEP
export SERVER_TYPE=FEP
#export JAVA_HOME=/usr/java/jdk1.7.0_80
export CRUZ_ROOT=/sw/cruzes/cruzlink
export CRUZ_LOGDIR=/logs/cruzes/
#################################
if [ ! -d "$CRUZ_LOGDIR" ];
then
        mkdir -p $CRUZ_LOGDIR
        echo "$CRUZ_LOGDIR create..."
	mkdir $CRUZ_LOGDIR/imanager
        echo "$CRUZ_LOGDIR/imanager create..."
	mkdir $CRUZ_LOGDIR/cruzStatistic
        echo "$CRUZ_LOGDIR/cruzStatistic create..."
	mkdir $CRUZ_LOGDIR/cruzSimul
        echo "$CRUZ_LOGDIR/cruzSimul create..."
fi
 
################################
# CruzES Version 
export FINNQ_VER=4.0.1
export RMT_VER=4.0.1
export POL_VER=4.0.1
export CVS_VER=4.0.1
export MT_VER=4.0.1
export STA_VER=4.0.1
export DEC_VER=4.0.1
export DW_VER=4.0.1
export JMX_VER=4.0.2
export HED_VER=4.0.1
export VO_VER=4.0.1
export CUS_VER=4.0.2
export COM_VER=4.0.2
export BAT_VER=4.0.2
export SIM_VER=4.0.1
export LOG_VER=4.0.1
export TCP_VER=4.0.2
export CNF_VER=4.0.1
export SYS_VER=4.0.1
export WSS_VER=4.0.1
export INK_VER=4.0.1
#################################
export CRUZ_BATDIR=/sw/cruzes/files
export CRUZ_NODENO={{ ansible_hostname[-2:] }}
export ENV_INFO_DVCD={{ENV_INFO_DVCD}}
export Server_IP={{ ansible_eth0["ipv4"]["address"] }}

##### DB Setting ######
#export JDBCDRIVER=oracle.jdbc.pool.OracleConnectionPoolDataSource
export JDBCDRIVER=org.mariadb.jdbc.Driver
export CONNECTIONURL={{CONNECTIONURL}}

##### MQ Setting ######
export CRUZ_MQ_BROKERURL=tcp://{{ ansible_eth0["ipv4"]["address"] }}:9093
export MGR_PORT=9094
export MGR_IP={{ ansible_eth0["ipv4"]["address"] }}
export ACTIVEMQ_HOME=$CRUZ_ROOT/cruzMQ

##### Invoke transform Setting ######
export invokeRcvPort=9095
export downloaderRcvPort=9092

##### MGT process Setting ######
export rcvPort=9096
export sendPort=9097
export jmxPort=9098

##### Monitoring Setting ######
export nodePortForMonitoring=9100

##### SIMUL Setting #####
export SIMUL_PORT=9099

##### MT Setting #####
export MT_IP={{ ansible_eth0["ipv4"]["address"] }}
export MT_PORT=9101

#### WSS Setting ####
export WSS_IP={{ ansible_eth0["ipv4"]["address"] }}
export WSS_PORT=9082

##### iManager Setting ######
export MANAGER_PORT=9080
export DB_USERNAME={{DB_USERNAME}}
export DB_PASSWORD={{DB_PASSWORD}}

##### FTS Setting #####
export FTS_PORT=9110



##### SESSION INFO Setting ######
export SESSION_PORT=9087

#### TRANSFER DB INFO Setting #####
export TRANSFER_DB_RECEIVER_PORT=10014
export TRANSFER_DB_SENDERER_PORT=10015

#export PATH=$PATH:$JAVA_HOME/bin:$ORACLE_HOME/bin:$CRUZ_ROOT/bin
export PATH=$PATH:$JAVA_HOME/bin:$CRUZ_ROOT/bin
export CLASSPATH=.:$JAVA_HOME/lib
export SHLIB_PATH=/usr/lib:$JAVA_HOME/jre/lib
export LIBPATH=/usr/lib:$JAVA_HOME/jre/lib

#======================================================================
# SOLUTION  ENV(JAVA)
#======================================================================
# for iManager
export grppath=$CRUZ_ROOT/router
export PROJECT_HOME=$CRUZ_ROOT/imanager
export BASEDIR=$CRUZ_ROOT/imanager/apache-tomcat-7.0.55
export TOMCAT_HOME=$BASEDIR
export CATALINA_HOME=$BASEDIR
export PATH=$PATH:$CATALINA_HOME/bin

# for Router
export CRUZ_BASE=$CRUZ_ROOT/cruzbase
export DBACCOUNT_PATH=$CRUZ_BASE/resources 
export MGT_HOME=$CRUZ_ROOT/cruzMgt

# for JTransform
export JTRANS_HOME=$CRUZ_ROOT/cruzJtrans
export PATH=$PATH:$JTRANS_HOME/bin

# for Batch
export CRUZ_BAT_HOME=$CRUZ_ROOT/batch
export CRUZ_FILE_DIR=$CRUZ_BATDIR
export CRUZ_SUB_DIR=src,src_tmp,src_bak,work,trans,linefeed,encrypt,decrypt,tgt,tgt_bak,err,snd,rcv,comm

# for EAI

# for C module ------------------------------------------------
## ORACLE ENV ##
#export ORACLE_SID=DVDSVR
#export TNS_ADMIN=$ORACLE_HOME/network/admin
#export NLS_LANG=American_america.KO16KSC5601
#export SHLIB_PATH=$SHLIB_PATH:$ORACLE_HOME:$ORACLE_HOME/lib
#export LD_LIBRARY_PATH=$ORACLE_HOME/lib32:$ORACLE_HOME/lib:/usr/lib
#export LIBPATH=$LIBPATH:$ORACLE_HOME/lib:$ORACLE_HOME/network/lib

## MGR ENV ##
#export PATH=$PATH:$CRUZ_BASE/mgr:$CRUZ_ROOT/bin
#export SHLIB_PATH=$SHLIB_PATH:$CRUZ_BASE/mgr/lib
#export LD_LIBRARY_PATH=.:/usr/lib:$ORACLE_HOME

#======================================================================
## ORACLE ENV ##
#======================================================================
#export TMPDIR=$ORACLE_BASE/tmp
#export TMP=$ORACLE_BASE/tmp

#export TMPDIR=/tmp
#export TMP=/tmp


#export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
#export LINK_CNTRL=L_PTHREADS_D7
#export CVSROOT=":pserver:cvs@ibm270:/home/cvs/CVSHOME"

#export LD_LIBRARY_PATH=/sw/damo:$LD_LIBRARY_PATH:$CRUZ_BASE/mgr/lib
#export SHLIB_PATH=/sw/damo:$SHLIB_PATH:$CRUZ_BASE/mgr/lib:$ORACLE_HOME
export SHLIB_PATH=/sw/damo:$SHLIB_PATH:$CRUZ_BASE/mgr/lib
export SHLIB_PATH=$SHLIB_PATH:$JAVA_HOME/jre/lib
export CLASSPATH=.

#======================================================================
# ALIAS
#======================================================================
alias ls="ls -aF"
alias ll="ls -alF"
alias vi=/bin/vi
alias vic="vi ~/.profile"
alias so=". ~/.profile"
#alias rh="cd $ROME_HOME"
alias so=". ~/.profile"
alias cls="/usr/bin/clear"
alias chkl="cvs stat -l |grep Status: |grep -v Up-to"
alias cvsu="cvs update "

alias iolog="tail -f $CRUZ_LOGDIR/imanager/iolog/io.log"
alias wplog="tail -f $CRUZ_LOGDIR/imanager/waplelog/waple.log"
alias wlog="tail -f $CRUZ_LOGDIR/imanager/waplelog/waple.log"
alias clog="tail -f $CRUZ_LOGDIR/imanager/catalina.out"
alias tdown="$TOMCAT_HOME/bin/shutdown.sh"
alias tstart="$TOMCAT_HOME/bin/startup.sh"
export LOG_DIR=$HOME/cruzlog
export logpath="$LOG_DIR/cruzlink"
export loggerpath="$LOG_DIR"

#alias mgrlog="tail -500f $CRUZ_LOGDIR/cruzbase/mq_mgr/mgr.log"
#alias mgrsyslog="tail -500f $CRUZ_LOGDIR/cruzbase/mq_mgr/mgr.system.log"
#alias mgrstart="exec nohup $CRUZ_ROOT/cruzbase/mq_mgr/bin/start > $CRUZ_LOGDIR/cruzbase/mq_mgr/mgr.system.log &"
#alias mgrstop="pskill mgr"

alias cruzadm_start_all="all_start.sh"
alias cruzadm_stop_all="all_stop.sh"
alias cruzadm_status="chkproc.sh"

#======================================================================
# FUNCTION
#======================================================================
DCOUNT=0
ds( )
{
    LCOUNT=0
    while true; do
        let LCOUNT=LCOUNT+1

        if [ $LCOUNT -gt $DCOUNT ]
            then
            break;
        fi

        if [ ! -z "${DDIR[${LCOUNT}]}" ]
        then
            echo [$LCOUNT] : ${DDIR[${LCOUNT}]}
        fi
    done
}

push( )
{
    if [ $# -eq 0 ]
    then
        let DCOUNT=DCOUNT+1
        DDIR[${DCOUNT}]=`pwd`
        echo [$DCOUNT] : ${DDIR[${DCOUNT}]}
        return
    fi

    if (( $# == 1 ))
    then
        #if [ $1 -le 0 ] || [ $1 -gt 9 ]
        if [ -d $1 ]
        then
            let DCOUNT=DCOUNT+1
            arg=$DCOUNT
            DDIR[${arg}]=$1
        else
            arg=$1
            DDIR[${arg}]=`pwd`
        fi
        echo [$arg] : ${DDIR[${arg}]}
        return
    fi

    if (( $# == 2 ))
    then
        if [ $1 -le 0 ] || [ $1 -gt 9 ]
        then
            echo argument [1-9] needed.
            return
        fi

        arg=$1
        DDIR[${arg}]=$2
        echo [$arg] : ${DDIR[${arg}]}
    fi
}

pop( )
{
    if (( $# > 0 ))
    then
        echo Usage : pop
        return
    fi

    echo [$DCOUNT] : ${DDIR[${DCOUNT}]}

    if [ ! -z "${DDIR[${DCOUNT}]}" ]
    then
        cd ${DDIR[${DCOUNT}]}
    fi
}

go( )
{
    if [ $# -eq 0 ]
    then
        ds
        return
    fi

    if [ $1 -le 0 ]
    then
        echo invalid argument
        return
    fi

    arg=$1
    echo [$arg] : ${DDIR[${arg}]}
    if [ ! -z "${DDIR[${arg}]}" ]
    then
        cd ${DDIR[${arg}]}
    fi
}

semkill()
{
	if [ $# -eq 0 ]
	then
		echo "Usage : semkill [pattern]"
	else
		if [ $# -eq 2 ]
		then
			ipcs -sa |grep $LOGNAME | grep $1 | grep $2 | grep -v grep | grep -v semkill > $HOME/.semkill
		else
			ipcs -sa |grep $LOGNAME | grep $1 | grep -v grep | grep -v semkill > $HOME/.semkill
		fi
		PIDS=`cat $HOME/.semkill | awk {'print $2'}`
		PNUMS=`wc -l $HOME/.semkill | awk {'print $1'}`
		echo
		cat $HOME/.semkill
		rm -f $HOME/.semkill
		if (( $PNUMS == 0 ))
		then
			echo
			echo No Semaphore ID. !!
		else
			echo
			echo $PNUMS Semaphore Listed.
			echo -n "Really Want to remove these Semaphores? (y/n)"
			read input
			if test ! -n "$input"
			then
				echo User Canceled !!
			else if [ $input = y ]
				then
					for PID in $PIDS; \
					do \
						ipcrm -s $PID;
						echo $PID be removed !!;
					done
				else
					echo User Canceled !!
				fi
			fi
		fi
	fi
	rm -f $HOME/.semkill
}                                                   

pss( )
{

    if [ $# -eq 0 ]
    then
        echo "Usage : pss [ProcessName]"
        return
    fi

    if [ $# -eq 2 ]
    then
        ps -fu $LOGNAME |grep $1 | grep $2 | grep -v grep | grep -v pskill > $HOME/.pss
    else
        ps -fu $LOGNAME |grep $1 | grep -v grep | grep -v pskill > $HOME/.pss
    fi

    echo
    cat $HOME/.pss
    PNUMS=`wc -l $HOME/.pss | awk '{print $1}'`
    rm -f $HOME/.pss
    echo
    echo $PNUMS Processes Listed.
}

pskill( )
{   
    if [ $# -eq 0 ]
    then
        echo "Usage : pskill [ProcessName]"
    else
        if [ $# -eq 2 ]
        then
            #ps -fu $LOGNAME |grep $1 | grep $2 | grep -v grep | grep -v pskill > $HOME/.pskill
		SIGNUM=$2
        else
		SIGNUM=9
        fi
		ps -fu $LOGNAME |grep $1 | grep $LOGNAME | grep -v grep | grep -v pskill | grep -v ksh > $HOME/.pskill
        PIDS=`cat $HOME/.pskill | awk {'print $2'}`
        PNUMS=`wc -l $HOME/.pskill | awk {'print $1'}`
        echo
        cat $HOME/.pskill
        rm -f $HOME/.pskill
        OS=`uname -s`
        echo
        echo $LOGNAME
        echo $PNUMS Processes Listed.

       	printf "Really Want to kill these processes? (y/n)"

        read input
        if test ! -n "$input"
        then
            echo User Canceled !!
        else if [ $input = y ]
            then
                for PID in $PIDS; \
                do \
                    kill -$SIGNUM $PID ;
                    echo $PID killed !!;
                done
            else
                echo User Canceled !!
            fi
        fi
    fi
}

pskillf( )
{
    if [ $# -eq 0 ]
    then
        echo "Usage : pskill [ProcessName]"
    else
        PIDS=`ps -fu $LOGNAME |grep $1 | grep $LOGNAME | grep -v grep | grep -v pskill | awk {'print $2'}`
        PNUMS=`echo $PIDS | wc -w | awk {'print $1'}`
        echo "=================================="
        echo "== Terminating $PNUMS Processes."
        for PID in $PIDS; \
        do \
           kill -9 $PID ;
           echo "==== $PID killed !!"
        done
        echo "=================================="
    fi
}
                                                                                                                  
replace()                                                                                                         
{                                                                                                                 
    if (( $# != 3 ))
    then
        echo "Usage : replace find_pattern replace_pattern file";
	return;
    fi

    cfgs=$3
    script="1,$$s/$1/$2/g"
    scfile=sc
    printf "1,\$s/%s/%s/g"  $1 $2> $scfile
    for file in $cfgs ; do
	#echo $file;
	/usr/xpg4/bin/sed  -f $scfile $file > tmp;
	mv tmp $file
    done
}


ff()
{
    if [ $# -lt 1 ];
	then
		echo Usage: ff filename
	else
		find . -name "*$1*" 
	fi
}

fd()
{                                
    if [ $# -lt 1 ];              
    then                           
        echo Usage: fd [c/h] pattern
    elif [ $# -eq 1 ];              
	then
		find . -name "*[c|h]" |xargs grep $1
    elif [ $# -eq 2 ];              
	then
		find . -name "*$1" |xargs grep $2
    fi                          
}             

ipcdel()
{
	if [ $# -eq 0 ]
	then
		echo "Usage : ipckill [pattern]"
	else
		shmkill $1
		semkill $1
	fi
}

shmkill( )
{
	if [ $# -eq 0 ]
	then
		echo "Usage : shmkill [pattern]"
	else
		if [ $# -eq 2 ]
		then
			ipcs -ma |grep $LOGNAME | grep $1 | grep $2 | grep -v grep | grep -v shmkill > $HOME/.shmkill
		else
			ipcs -ma |grep $LOGNAME | grep $1 | grep -v grep | grep -v shmkill > $HOME/.shmkill
		fi

		PIDS=`cat $HOME/.shmkill | awk {'print $2'}`
		PNUMS=`wc -l $HOME/.shmkill | awk {'print $1'}`
		echo
		cat $HOME/.shmkill
		rm -f $HOME/.shmkill
		echo
		echo $PNUMS Shared Memory Segments Listed.
		OS=`uname -s`
        if [ ${OS} = "Linux" ];
        then
			echo -n "Really Want to remove these SHM? (y/n)"
        else
			echo "Really Want to remove these SHM? (y/n)\c"
		fi
		read input
		if test ! -n "$input"
		then
			echo User Canceled !!
		else if [ $input = y ]
			then
				for PID in $PIDS; \
				do \
					ipcrm -m $PID;
					echo $PID be removed !!;
				done
			else
				echo User Canceled !!
			fi
		fi
	fi
}


push $CRUZ_ROOT
push $CRUZ_BASE
push $CRUZ_ROOT/router
push $CRUZ_LOGDIR
#push $CRUZ_ROOT/imanager
#push $JTRANS_HOME
#push $CRUZ_LOGDIR/router1
#push $CRUZ_LOGDIR/grponline/router1
echo
echo "[Info 1] move directories DIRECTOLY!!                 # go 1"
echo "[Info 2] if you want to push directory just type      # push [dir]"
echo "[Info 3] if you want to retrive directories just type # ds"
echo
NLSPATH=/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/KO_KR/%N:/usr/lib/nls/msg/eucKR/%N:/usr/lib/nls/msg/%L/%N.cat:/usr/lib/nls/msg/KO_KR/%N.cat:/usr/lib/nls/msg/eucKR/%N.cat
export NLSPATH

#. /tscruz/tuxedo/tux.env
