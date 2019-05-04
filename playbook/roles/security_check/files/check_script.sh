#!/bin/sh

if [ "$EUID" -ne 0 ]
    then echo "root 권한으로 실행 필요"
    exit
fi

HOSTNAME=`hostname`
RESULT_FILE=$HOSTNAME-linux-result-`date +%F`.txt
OS_VERSION=

echo "-------------------------------------------------------------------"
echo "              Finnq 서버 보안 취약성 점검 (Linux)                    "
echo "-------------------------------------------------------------------"

echo "-------------------------------------------------------------------" > $RESULT_FILE 2>&1
echo "              Finnq 서버 보안 취약성 점검 (Linux)                    " >> $RESULT_FILE 2>&1
echo "-------------------------------------------------------------------" >> $RESULT_FILE 2>&1

sleep 3

echo "--------------------- 점검 시작 시간  ------------------------------"
date
echo "--------------------- 점검 시작 시간  ------------------------------" > $RESULT_FILE 2>&1
date >> $RESULT_FILE 2>&1

echo "--------------------- 시스템 정보 ---------------------------------"
echo "--------------------- 시스템 정보 ---------------------------------" >> $RESULT_FILE 2>&1
echo "OS: "`cat /etc/system-release`
echo "hostname: "`uname -n`
echo "kernel version: "`uname -r`
echo "OS: "`cat /etc/system-release` >> $RESULT_FILE 2>&1
echo "hostname: "`uname -n` >> $RESULT_FILE 2>&1
echo "kernel version: "`uname -r`  >> $RESULT_FILE 2>&1

echo "--------------------- 네트워크 정보 ---------------------------------"
echo "--------------------- 네트워크 정보 ---------------------------------" >> $RESULT_FILE 2>&1
ifconfig -a  >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1


echo "--------------------- 점검 시작 ---------------------------------"
echo "--------------------- 점검 시작 ---------------------------------" >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1
echo  >> $RESULT_FILE 2>&1

echo "SRV-001 SNMP 서비스 GET community 스트링 설정 오류 점검"
echo "SRV-001 SNMP 서비스 GET community 스트링 설정 오류 점검" >> $RESULT_FILE 2>&1
# 결과 취합의 위해 서비스 코드와 결과 값을 변수 처리
SVR_CODE=SRV-001
RST_CODE=Pass # 결과 Pass 또는 Fail 로 정리

if [ -f "/etc/snmpd.conf" ]
then
  echo "GET community"`cat /etc/snmpd.conf | grep rocommunity` >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SNMP 서비스 비활성화됨" 
  echo "SNMP 서비스 비활성화됨" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-002 SNMP 서비스 SET community 스트링 설정 오류 점검"
echo "SRV-002 SNMP 서비스 SET community 스트링 설정 오류 점검" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-002

if [ -f "/etc/snmpd.conf" ]
then
  echo "GET community"`cat /etc/snmpd.conf | grep rwcommunity` >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SNMP 서비스 비활성화됨" 
  echo "SNMP 서비스 비활성화됨" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-004 불필요한 SMTP 서비스 실행 여부"
echo "SRV-004 불필요한 SMTP 서비스 실행 여부" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-004

USESMTP=false

if [ `cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="smtp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp" >> $RESULT_FILE 2>&1
    USESMTP=true
		RST_CODE=Fail		
  else
    echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
		RST_CODE=Pass
	fi
fi
# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-005 SMTP 서비스 expn/vrfy 명령어 실행 가능 여부"
echo "SRV-005 SMTP 서비스 expn/vrfy 명령어 실행 가능 여부" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-005

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-006 Sendmail Log Level 미설정"
echo "SRV-006 Sendmail Log Level 미설정" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-006

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-007 취약한 버전의 Sendmail 사용 여부"
echo "SRV-007 취약한 버전의 Sendmail 사용 여부" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-007

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-008 취약한 버전의 Sendmail 사용 여부"
echo "SRV-008 취약한 버전의 Sendmail 사용 여부" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-008

result_tmp=0

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-009 스팸  메일 릴레이 제한"
echo "SRV-009 스팸  메일 릴레이 제한" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-009

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-010 일반사용자의 Sendmail 실행 방지"
echo "SRV-010 일반사용자의 Sendmail 실행 방지" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-010

if $USESMTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-011	ftpusers 파일 내 시스템 계정 존재 여부"
echo "SRV-011	ftpusers 파일 내 시스템 계정 존재 여부" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-011

USEFTP=false
RST_CODE=Fail

if [ `cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ftp" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp" >> $RESULT_FILE 2>&1
    USEFTP=true
  else
    echo "SMTP 서비스 비활성화" >> $RESULT_FILE 2>&1
		RST_CODE=Pass
	fi
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-012	.netrc 파일 내 호스트 정보 노출"
echo "SRV-012	.netrc 파일 내 호스트 정보 노출" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-012

if [ `find / -name .netrc |wc -l` -gt 0 ]
then
	find / -name .netrc >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-013	Anonymous FTP 비활성화"
echo "SRV-013	Anonymous FTP 비활성화"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-013

if $USEFTP
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "FTP 서비스 비활성화" >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi 
USENFS=false

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-014	NFS 접근통제"
echo "SRV-014	NFS 접근통제"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-014

if [ `ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep" | wc -l` -gt 0 ] 
then
  ps -ef | grep "nfsd" | egrep -v "statdaemon|automountd|emi" | grep -v "grep"  >> $RESULT_FILE 2>&1
  USENFS=true
 RST_CODE=Fail
else
  echo "NFS Service Disable"  >> $RESULT_FILE 2>&1
  USENFS=false
 RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-015	NFS 비활성화"
echo "SRV-015	NFS 비활성화"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-015

if $USENFS
then
  echo "<<<<<<<<<<<<<<<<<<<< TODO >>>>>>>>>>>>>>>>" >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "NFS 서비스 비활성화"  >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-016	불필요한 RPC서비스 구동 여부" 
echo "SRV-016	불필요한 RPC서비스 구동 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-016

SERVICE="rpc.cmsd|rpc.ttdbserverd|sadmind|rusersd|walld|sprayd|rstatd|rpc.nisd|rexd|rpc.pcnfsd|rpc.statd|rpc.ypupdated|rpc.rquotad|kcms_server|cachefsd"

if [ `ps -ef | egrep $SERVICE | grep -v "grep"|grep -v "vxvvrstatd" | wc -l` -eq 0 ]
then
	echo "RPC Service Disable"  >> $RESULT_FILE 2>&1
	RST_CODE=Pass
else
	echo "RPC Enabled!!!!!!!!!!"  >> $RESULT_FILE 2>&1
	ps -ef | egrep $SERVICE | grep -v "grep"  >> $RESULT_FILE 2>&1
	RST_CODE=Fail
fi
# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1


echo "SRV-017	automountd 제거"
echo "SRV-017	automountd 제거"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-017

if [ `ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi" | wc -l` -gt 0 ] 
then
  ps -ef | egrep 'automount|autofs' | grep -v "grep" | egrep -v "statdaemon|emi"  >> $RESULT_FILE 2>&1
	RST_CODE=Fail
else
  echo "Automountd Daemon Disable"  >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-019	tftp, talk 서비스 비활성화"
echo "SRV-019	tftp, talk 서비스 비활성화"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-019
RST_CODE=Fail

cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp"                    >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp"                    >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "  " $2}' | grep "udp"                    >> $RESULT_FILE 2>&1
if [ `cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="tftp" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > SRV-019.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="talk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > SRV-019.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="ntalk" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > SRV-019.txt
	fi
fi

if [ -f SRV-019.txt ]
then
	rm -rf SRV-019.txt
else
	echo "tftp, talk, ntalk Service Disable"                                                  >> $RESULT_FILE 2>&1
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-025	$HOME/.rhosts, hosts.equiv 사용 금지"
echo "SRV-025	$HOME/.rhosts, hosts.equiv 사용 금지"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-025

result_tmp=0

cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1

if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep ":$port " | grep -i "^tcp"                                                > SRV-025.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep ":$port " | grep -i "^tcp"                                                >> SRV-025.txt
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	netstat -na | grep ":$port " | grep -i "^tcp"                                                >> SRV-025.txt
fi

if [ -s SRV-025.txt ]
then
	cat SRV-025.txt | grep -v '^ *$'                                                                >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
else
	echo "☞ r-command Service Disable"                                                          >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "③ /etc/hosts.equiv 파일 설정"                                                           >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1

if [ -f /etc/hosts.equiv ]
	then
		echo "(1) Permission: (`ls -al /etc/hosts.equiv`)"                                         >> $RESULT_FILE 2>&1
		echo "(2) 설정 내용:"                                                                      >> $RESULT_FILE 2>&1
		echo "----------------------------------------"                                            >> $RESULT_FILE 2>&1
		if [ `cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
		then
			cat /etc/hosts.equiv | grep -v "#" | grep -v '^ *$'                                      >> $RESULT_FILE 2>&1
			result_tmp=$(($result_tmp+1))
		else
			echo "설정 내용이 없습니다."                                                             >> $RESULT_FILE 2>&1
			result_tmp=$(($result_tmp+0))
		fi
	else
		echo "/etc/hosts.equiv 파일이 없습니다."                                                   >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "④ 사용자 home directory .rhosts 설정 내용"                                              >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
HOMEDIRS=`cat /etc/passwd | awk -F":" 'length($6) > 0 {print $6}' | sort -u`
FILES="/.rhosts"

for dir in $HOMEDIRS
do
	for file in $FILES
	do
		if [ -f $dir$file ]
		then
			echo " "                                                                                 > rhosts.txt
			echo "# $dir$file 파일 설정:"                                                            >> $RESULT_FILE 2>&1
			echo "(1) Permission: (`ls -al $dir$file`)"                                              >> $RESULT_FILE 2>&1
			echo "(2) 설정 내용:"                                                                    >> $RESULT_FILE 2>&1
			echo "----------------------------------------"                                          >> $RESULT_FILE 2>&1
			if [ `cat $dir$file | grep -v "#" | grep -v '^ *$' | wc -l` -gt 0 ]
			then
				cat $dir$file | grep -v "#" | grep -v '^ *$'                                           >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+1))
			else
				echo "설정 내용이 없습니다."                                                           >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+0))
			fi
		echo " "                                                                                   >> $RESULT_FILE 2>&1
		fi
	done
done
if [ ! -f rhosts.txt ]
then
	echo ".rhosts 파일이 없습니다."                                                              >> $RESULT_FILE 2>&1
	echo " "                                                                                     >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

rm -rf rhosts.txt
rm -rf SRV-025.txt
echo " "                                                                                       >> $RESULT_FILE 2>&1

echo "SRV-026	root 계정 원격 접속 제한"
echo "SRV-026	root 계정 원격 접속 제한"  >> $RESULT_FILE 2>&1

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp"                  >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $RESULT_FILE 2>&1
SVR_CODE=SRV-026

result_tmp=0

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="telnet" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	else
		echo "☞ Telnet Service Disable"                                                           >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	fi
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "③ /etc/securetty 파일 설정"                                                             >> $RESULT_FILE 2>&1

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `cat /etc/securetty | grep "pts" | wc -l` -gt 0 ]
then
	cat /etc/securetty | grep "pts"                                                              >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
else
	echo "/etc/securetty 파일에 pts/0~pts/x 설정이 없습니다."                                    >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "④ /etc/pam.d/login 파일 설정"                                                           >> $RESULT_FILE 2>&1

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `cat /etc/pam.d/login | grep "pam_securetty.so"|wc -l` -gt 0 ]
then
	cat /etc/pam.d/login | grep "pam_securetty.so"                                                 >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
else
  echo "pam_securetty.so 설정이 없습니다." >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-027	접속 IP 및 포트 제한"
echo "SRV-027	접속 IP 및 포트 제한"  >> $RESULT_FILE 2>&1

echo "① /etc/hosts.allow 파일 설정"                                                           >> $RESULT_FILE 2>&1
SVR_CODE=SRV-027

result_tmp=0

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ -f /etc/hosts.allow ]
then
	if [ ! `cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.allow | grep -v "#" | grep -ve '^ *$'                                       >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	else
		echo "설정 내용이 없습니다."                                                               >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	fi
else
	echo "/etc/hosts.allow 파일이 없습니다."                                                     >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "② /etc/hosts.deny 파일 설정"                                                            >> $RESULT_FILE 2>&1

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ -f /etc/hosts.deny ]
then
	if [ ! `cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$' | wc -l` -eq 0 ]
	then
		cat /etc/hosts.deny | grep -v "#" | grep -ve '^ *$'                                        >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	else
		echo "설정 내용이 없습니다."                                                               >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	fi
else
	echo "/etc/hosts.deny 파일이 없습니다."                                                      >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-030	Finger 서비스 비활성화"
echo "SRV-030	Finger 서비스 비활성화"  >> $RESULT_FILE 2>&1

echo "① /etc/services 파일에서 포트 확인"                                                     >> $RESULT_FILE 2>&1
SVR_CODE=SRV-030

result_tmp=0

echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp"                  >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="finger" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                           >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	else
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	fi
else
	if [ `netstat -na | grep ":79 " | grep -i "^tcp" | wc -l` -eq 0 ]
	then
		echo "☞ Finger Service Disable"                                                           >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	else
		netstat -na | grep ":79 " | grep -i "^tcp"                                                 >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	fi
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-033	불필요한 DMI 서비스 구동 여부"
echo "SRV-033	불필요한 DMI 서비스 구동 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-033

echo "Linux OS, 해당사항 없음"  >> $RESULT_FILE 2>&1
RST_CODE=Pass
# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-035	r 계열 서비스 비활성화"
echo "SRV-035	r 계열 서비스 비활성화"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-035

result_tmp=0

echo "/etc/services 파일에서 포트 확인"                                                     >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="exec" {print $1 "    " $2}' | grep "tcp"                   >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "② 서비스 포트 활성화 여부 확인(서비스 중지시 결과 값 없음)"                             >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1

if [ `cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="login" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="shell" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="exec" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > rcommand.txt
	fi
fi

if [ -f rcommand.txt ]
then
	rm -rf rcommand.txt
	result_tmp=$(($result_tmp+1))
else
	echo "☞ r-commands Service Disable"                                                         >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-036	DoS 공격에 취약한 서비스 비활성화"
echo "SRV-036	DoS 공격에 취약한 서비스 비활성화"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-036

result_tmp=0

echo "① /etc/services 파일에서 포트 확인"                                                     >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "tcp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="echo" {print $1 "      " $2}' | grep "udp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp"                 >> $RESULT_FILE 2>&1
cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp"                 >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "② 서비스 포트 활성화 여부 확인"                                                         >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="echo" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="discard" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="daytime" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "tcp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^tcp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^tcp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ `cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}' | wc -l` -gt 0 ]
then
	port=`cat /etc/services | awk -F" " '$1=="chargen" {print $1 "   " $2}' | grep "udp" | awk -F" " '{print $2}' | awk -F"/" '{print $1}'`;
	if [ `netstat -na | grep ":$port " | grep -i "^udp" | wc -l` -gt 0 ]
	then
		netstat -na | grep ":$port " | grep -i "^udp"                                              >> $RESULT_FILE 2>&1
		echo " "                                                                                   > unnecessary.txt
	fi
fi

if [ -f unnecessary.txt ]
then
	rm -rf unnecessary.txt
	result_tmp=$(($result_tmp+1))
else
	echo "불필요한 서비스가 동작하고 있지 않습니다.(echo, discard, daytime, chargen)"            >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-039	불필요한 Tmax WebtoB 서비스 구동 여부"
echo "SRV-039	불필요한 Tmax WebtoB 서비스 구동 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-039

echo "Tmax WebtoB 서비스 사용하지 않음"  >> $RESULT_FILE 2>&1
RST_CODE=Pass
# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-040	Apache 디렉토리 리스팅 제거"
echo "SRV-040	Apache 디렉토리 리스팅 제거"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-040

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		if [ `grep "\+Indexes" $i |wc -l` -gt 0 ]
		then
			result_tmp=$(($result_tmp+1))
			echo "$i Apache 디렉토리 리스팅 Config!!"
			echo "$i Apache 디렉토리 리스팅 Config!!" >> $RESULT_FILE 2>&1
		else
			result_tmp=$(($result_tmp+0))
			echo "$i Apache 디렉토리 리스팅 Not Config!!"
			echo "$i Apache 디렉토리 리스팅 Not Config!!" >> $RESULT_FILE 2>&1
		fi
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-042	Apache 상위 디렉토리 접근 금지"
echo "SRV-042	Apache 상위 디렉토리 접근 금지"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-042

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
 then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		if [ `grep "AllowOverride" $i| grep -v "#" | egrep -v "AuthConfig|All"|wc -l` -gt 0 ]
		then
			result_tmp=$(($result_tmp+1))
			echo "$i Apache 디렉토리 접근 금지 Config!!"
			echo "$i Apache 디렉토리 접근 금지 Config!!" >> $RESULT_FILE 2>&1
		else
			result_tmp=$(($result_tmp+0))
			echo "$i Apache 디렉토리 접근 금지 Not Config!!"
			echo "$i Apache 디렉토리 접근 금지 Not Config!!" >> $RESULT_FILE 2>&1
		fi
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-043	Apache 불필요한 파일 제거"
echo "SRV-043	Apache 불필요한 파일 제거"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-043

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
 then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		for j in `grep "^DocumentRoot" $i|awk -F \" '{print $2}'`
		do
			AHOME=$j
			if [ -d $AHOME/cgi-bin ]
			then
				echo "☞ $AHOME/cgi-bin 파일"                                                              >> $RESULT_FILE 2>&1
				echo "------------------------------------------------------------------------------"      >> $RESULT_FILE 2>&1
				ls -ld $AHOME/cgi-bin/test-cgi                                                             >> $RESULT_FILE 2>&1
				ls -ld $AHOME/cgi-bin/printenv                                                             >> $RESULT_FILE 2>&1
				echo " "                                                                                   >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+1))
			else
				echo "☞ $AHOME/cgi-bin 디렉터리가 제거되어 있습니다.(양호)"                               >> $RESULT_FILE 2>&1
				echo " "                                                                                   >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+0))
			fi

			if [ -d $AHOME/htdocs/manual ]
			then
				echo "☞ $AHOME/htdocs/manual 파일"                                                        >> $RESULT_FILE 2>&1
				echo "------------------------------------------------------------------------------"      >> $RESULT_FILE 2>&1
				ls -ld $AHOME/htdocs/manual                                                                >> $RESULT_FILE 2>&1
				echo " "                                                                                   >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+1))
			else
				echo "☞ $AHOME/htdocs/manual 디렉터리가 제거되어 있습니다.(양호)"                         >> $RESULT_FILE 2>&1
				echo " "                                                                                   >> $RESULT_FILE 2>&1
				result_tmp=$(($result_tmp+0))
			fi
		done
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-044	Apache 파일 업로드 및 다운로드 제한"
echo "SRV-044	Apache 파일 업로드 및 다운로드 제한"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-044

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
 then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		for j in `grep "LimitRequestBody" $i|awk '{print $2}'`
		do
			if [ $j -gt 5000000 ]
			then
				result_tmp=$(($result_tmp+1))
				echo "$i LimitRequestBody is Over 500000!!"
				echo "$i LimitRequestBody is Over 500000!!" >> $RESULT_FILE 2>&1
			else
			result_tmp=$(($result_tmp+0))
			echo "$i LimitRequestBody is Under 500000!!"
			echo "$i LimitRequestBody is Under 500000!!" >> $RESULT_FILE 2>&1
			fi
		done
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Except
else
	RST_CODE=Except
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-045	Apache 웹 프로세스 권한 제한"
echo "SRV-045	Apache 웹 프로세스 권한 제한"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-045

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
 then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		if [ "`grep "^User" $i|awk '{print $2}'`" == "root" -o "`grep "^Group" $i|awk '{print $2}'`" == "root" ]
		then
			result_tmp=$(($result_tmp+1))
			echo "$i Apache User is root!!"
			echo "$i Apache User is root!!" >> $RESULT_FILE 2>&1
		else
			result_tmp=$(($result_tmp+0))
			echo "$i Apache User is Not root!!"
			echo "$i Apache User is Not root!!" >> $RESULT_FILE 2>&1
		fi
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-046	Apache 웹 서비스 영역의 분리"
echo "SRV-046	Apache 웹 서비스 영역의 분리"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-046

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		if [ `grep ^DocumentRoot $i|awk  '{print $2}'` == "/usr/local/apache/htdocs" -o `grep ^DocumentRoot $i|awk '{print $2}'` == "/home/apache/htdocs" ]
		then
			result_tmp=$(($result_tmp+1))
			echo "$i Apache DocumentRoot is Default!!"
			echo "$i Apache DocumentRoot is Default!!" >> $RESULT_FILE 2>&1
		else
			result_tmp=$(($result_tmp+0))
			echo "$i Apache DocumentRoot is Not Default!!"
			echo "$i Apache DocumentRoot is Not Default!!" >> $RESULT_FILE 2>&1
		fi
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-047	Apache 링크 사용금지 여부"
echo "SRV-047	Apache 링크 사용금지 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-047

result_tmp=0

if [ `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq|wc -l` -gt 0 ]
 then
 	for i in `ps -ef |grep httpd |grep -v grep |grep httpd.conf|awk '{print $12}'|sort|uniq`
	do
		if [ `grep "\+FollowSymLinks" $i |wc -l` -gt 0 ]
		then
			result_tmp=$(($result_tmp+1))
			echo "$i Apache 링크 사용 Config!!"
			echo "$i Apache 링크 사용 Config!!" >> $RESULT_FILE 2>&1
		else
			result_tmp=$(($result_tmp+0))
			echo "$i Apache 링크 사용 Not Config!!"
			echo "$i Apache 링크 사용 Not Config!!" >> $RESULT_FILE 2>&1
		fi
	done
else
	result_tmp=$(($result_tmp+0))
	echo "Httpd Not Running!!"
	echo "Httpd Not Running!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-060	미흡한 Apache Tomcat 기본 계정 사용 여부"
echo "SRV-060	미흡한 Apache Tomcat 기본 계정 사용 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-060

result_tmp=0

if [ -f "/sw/tomcat/conf/tomcat_user.xml" ]
then
  cat /sw/tomcat/conf/tomcat_user.xml >> $RESULT_FILE 2>&1
  echo " " >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
else
  echo "Apache tomcat service Disabled" >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-061	DNS Inverse Query 설정 오류"
echo "SRV-061	DNS Inverse Query 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-061

result_tmp=0

if [ `ps -ef | grep "named" | grep -v "grep" | wc -l` -eq 0 ]
then
  echo "DNS service disabled"  >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
else 
  if [ `cat /etc/named.conf |grep fake |wc -l` -eq 0 ]
	then
    echo "DNS Enabled and no Inverse query..OK"  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
  else
    echo "DNS Enabled and EXIST Inverse query.."  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
  fi
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-062	BIND 서버 버전 노출 여부"
echo "SRV-062	BIND 서버 버전 노출 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-062

result_tmp=0

if [ `ps -ef | grep "named" | grep -v "grep" | wc -l` -eq 0 ]
then
  echo "DNS service disabled"  >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
else 
  if [ `cat /etc/named.conf |grep version |wc -l` -eq 0 ]
	then
    echo "DNS Enabled and no version info..OK"  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
  else
    echo "DNS Enabled and EXIST version info.."  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
  fi
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-063	DNS Recursive Query 설정 미흡"
echo "SRV-063	DNS Recursive Query 설정 미흡"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-063

result_tmp=0

if [ `ps -ef | grep "named" | grep -v "grep" | wc -l` -eq 0 ]
then
  echo "DNS service disabled"  >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
else 
  if [ `cat /etc/named.conf |grep ^allow-recursion |grep -v "//"|wc -l` -eq 0 ]; then
    echo "DNS Enabled and no allow-recursion info..OK"  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
  else
    echo "DNS Enabled and EXIST and allow-recursion info.."  >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
  fi
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-064	DNS 보안 버전 패치"
echo "SRV-064	DNS 보안 버전 패치"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-064

result_tmp=0

DNSPR=`ps -ef | grep named | grep -v "grep" | awk 'BEGIN{ OFS="\n"} {i=1; while(i<=NF) {print $i; i++}}'| grep "/" | uniq`
DNSPR=`echo $DNSPR | awk '{print $1}'`
if [ `ps -ef | grep named | grep -v grep | wc -l` -gt 0 ]
then
	if [ -f $DNSPR ]
	then
    echo "BIND 버전 확인"                                                                      >> $RESULT_FILE 2>&1
    echo "------------------------------------------------------------------------------"      >> $RESULT_FILE 2>&1
    $DNSPR -v | grep BIND                                                                      >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
  else
    echo "$DNSPR 파일이 없습니다."                                                             >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
  fi
else
  echo "☞ DNS Service Disable"                                                                >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-065	NIS, NIS+ 점검"
echo "SRV-065	NIS, NIS+ 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-065

SERVICE="ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated|rpc.nids"

if [ `ps -ef | egrep $SERVICE | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ NIS, NIS+ Service Disable"                                                        >> $RESULT_FILE 2>&1
	RST_CODE=Pass
else
	echo "☞ NIS+ 데몬은 rpc.nids임"														   >> $RESULT_FILE 2>&1
	ps -ef | egrep $SERVICE | grep -v "grep"                                                   >> $RESULT_FILE 2>&1
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-066	DNS Zone Transfer 설정"
echo "SRV-066	DNS Zone Transfer 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-066

result_tmp=0

echo "① DNS 프로세스 확인 " >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ `ps -ef | grep named | grep -v "grep" | wc -l` -eq 0 ]
then
	echo "☞ DNS Service Disable"                                                                >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
else
	ps -ef | grep named | grep -v "grep"                                                         >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
if [ `ls -al /etc/rc*.d/* | grep -i named | grep "/S" | wc -l` -gt 0 ]
then
	ls -al /etc/rc*.d/* | grep -i named | grep "/S"                                              >> $RESULT_FILE 2>&1
	echo " "                                                                                     >> $RESULT_FILE 2>&1
fi

echo "② /etc/named.conf 파일의 allow-transfer 확인"                                           >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1

if [ -f /etc/named.conf ]
then
	if [ `cat /etc/named.conf | grep 'allow-transfer'|wc -l` -eq 0 ]
	then
		result_tmp=$(($result_tmp+0))
	else 
	result_tmp=$(($result_tmp+1))
	cat /etc/named.conf | grep 'allow-transfer'
	cat /etc/named.conf | grep 'allow-transfer' >> $RESULT_FILE 2>&1
	fi
else
	echo "/etc/named.conf 파일이 없습니다."                                                      >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "③ /etc/named.boot 파일의 xfrnets 확인"                                                  >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1

if [ -f /etc/named.boot ]
then
	cat /etc/named.boot | grep "\xfrnets"                                                        >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
else
	echo "/etc/named.boot 파일이 없습니다."                                                      >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-068	계정에 대한 비밀번호 미설정"
echo "SRV-068	계정에 대한 비밀번호 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-068

echo "정기적으로 갱신 중, LDAP 및 local 계정" >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
RST_CODE=Pass
# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-070	비밀번호 저장파일 보호"
echo "SRV-070	비밀번호 저장파일 보호"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-070

result_tmp=0

if [ -f /etc/passwd ]
then
	if [ `awk -F: '$2=="x"' /etc/passwd | wc -l` -eq 0 ]
	then
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있지 않습니다."                       >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+1))
	else
		echo "☞ /etc/passwd 파일에 패스워드가 암호화 되어 있습니다."                            >> $RESULT_FILE 2>&1
		result_tmp=$(($result_tmp+0))
	fi
	echo " "                                                                                     >> $RESULT_FILE 2>&1
	echo "[참고]"                                                                                >> $RESULT_FILE 2>&1
	echo "------------------------------------------------------------------------------"        >> $RESULT_FILE 2>&1
	cat /etc/passwd | head -5                                                                    >> $RESULT_FILE 2>&1
	echo "이하생략..."                                                                           >> $RESULT_FILE 2>&1
else
	echo "☞ /etc/passwd 파일이 없습니다."                                                       >> $RESULT_FILE 2>&1
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "1.04 END"                                                                                >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "■ /etc/passwd 파일"                                                                      >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ -f /etc/passwd ]
then
  cat /etc/passwd                                                                              >> $RESULT_FILE 2>&1
else
	echo "/etc/shadow 파일이 없습니다."                                                          >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
fi
echo " "                                                                                       >> $RESULT_FILE 2>&1
echo "■ /etc/shadow 파일"                                                                      >> $RESULT_FILE 2>&1
echo "------------------------------------------------------------------------------"          >> $RESULT_FILE 2>&1
if [ -f /etc/shadow ]
then
  cat /etc/shadow                                                                              >> $RESULT_FILE 2>&1
else
  echo "/etc/shadow 파일이 없습니다."                                                          >> $RESULT_FILE 2>&1
	result_tmp=$(($result_tmp+1))
fi

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-073	관리자 그룹에 최소한의 사용자 포함"
echo "SRV-073	관리자 그룹에 최소한의 사용자 포함"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-073

echo "/etc/group 파일 내 root:x:0: 에 다른 그룹 또는 사용자가 포함되어 있는지 확인"   >> $RESULT_FILE 2>&1
if [ `cat /etc/group |grep root:x|wc -l` -gt 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi
cat /etc/group |grep root:x >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-074	비밀번호 장기간 미변경 계정 존재"
echo "SRV-074	비밀번호 장기간 미변경 계정 존재"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-074

echo "비밀번호는 secuvtos & LDAP 에서 관리"   >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
RST_CODE=Pass

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-075	유추가능한 비밀번호 사용 여부"
echo "SRV-075	유추가능한 비밀번호 사용 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-075

echo "비밀번호는 secuvtos & LDAP 에서 관리"   >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
RST_CODE=Pass

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-076	비밀번호 복잡성 설정"
echo "SRV-076	비밀번호 복잡성 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-076

echo "비밀번호는 secuvtos & LDAP 에서 관리"   >> $RESULT_FILE 2>&1
echo " "                                                                                       >> $RESULT_FILE 2>&1
RST_CODE=Pass

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-081	Crontab 설정파일 권한 설정"
echo "SRV-081	Crontab 설정파일 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-081

if [ `stat -c "%a %n" /var/spool/cron/*|awk '{print $1}'|xargs -i expr substr {} 3 1` -gt 0 ]
then
	RST_CODE=Fail
else
	RST_CODE=Pass
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-082	시스템 디렉토리 권한설정 미비"
echo "SRV-082	시스템 디렉토리 권한설정 미비"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-082

result_tmp=0

for i in bin etc sbin usr var
do 
  if [ "`ls -lLd /$i |grep ^d|xargs -i expr substr {} 9 1`" == "-" ]
	then
		result_tmp=$(($result_tmp+0))
	else
		result_tmp=$(($result_tmp+1))
		echo "Directory $i is other write permission!!" >> $RESULT_FILE 2>&1
	fi 
done

if [ $result_tmp -eq 0 ]
	then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-083	시스템 스타트업 스크립트 권한 설정 오류"
echo "SRV-083	시스템 스타트업 스크립트 권한 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-083

result_tmp=0

for i in  /etc/init.d /etc/rc2.d /etc/rc3.d /etc/rc.d/init.d /etc/rc.d/rc2.d /etc/rc.d/rc3.d /sbin/init.d /sbin/rc2.d /sbin/rc3.d
do
  if [ -d  $i ]
  then
		for j in `ls -lL "$i" |grep ^-|awk '{print $9}'`
	  do
   		if [ "`ls -lL $i/$j |xargs -i expr substr {} 9 1`" == "-" ]
 			then
   	  	result_tmp=$(($result_tmp+0))
     	else
        result_tmp=$(($result_tmp+1))
        echo "$i is write permission!!"  >> $RESULT_FILE 2>&1
      fi
    done
    else
      echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
    fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-084	/etc/passwd 파일 소유자 및 권한 설정"
echo "SRV-084	/etc/passwd 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-084

result_tmp=0

if [ `stat -c "%g" /etc/passwd` -eq 0 ]
then
		result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
  echo "/etc/passwd is group is not root!!"
	echo "/etc/passwd is group is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%u" /etc/passwd` -eq 0 ]
then
		result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/passwd is owner is not root!!"
  echo "/etc/passwd is owner is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%a" /etc/passwd` -eq 644 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/passwd is Not 644 Permission!!"
  echo "/etc/passwd is Not 644 Permission!!" >> $RESULT_FILE 2>&1
fi 

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-085	/etc/shadow 파일 소유자 및 권한 설정"
echo "SRV-085	/etc/shadow 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-085

result_tmp=0

if [ `stat -c "%g" /etc/shadow` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
  echo "/etc/passwd is group is not root!!"
	echo "/etc/passwd is group is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%u" /etc/shadow` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/shadow is owner is not root!!"
  echo "/etc/shadow is owner is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%a" /etc/shadow` -le 400 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/shadow is Not 400 Permission!!"
  echo "/etc/shadow is Not 400 Permission!!" >> $RESULT_FILE 2>&1
fi 

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-086	/etc/hosts 파일 소유자 및 권한 설정"
echo "SRV-086	/etc/hosts 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-086

result_tmp=0

if [ `stat -c "%g" /etc/hosts` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
  echo "/etc/hosts is group is not root!!"
	echo "/etc/hosts is group is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%u" /etc/hosts` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/hosts is owner is not root!!"
  echo "/etc/hosts is owner is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%a" /etc/hosts` -eq 600 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/hosts is `stat -c "%a" /etc/hosts` Permission!!"
  echo "/etc/hosts is `stat -c "%a" /etc/hosts` Permission!!" >> $RESULT_FILE 2>&1
fi 

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Except
else
	RST_CODE=Except
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-087	C 컴파일러 존재 및 권한 설정 오류"
echo "SRV-087	C 컴파일러 존재 및 권한 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-087

result_tmp=0

for i in /usr/bin/cc /usr/bin/gcc /usr/ucb/cc /usr/ccs/bin/cc 
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ `stat -c "%u" $i` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is not root!!"
			echo "$i is owner is not root!!" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 750 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is Not 750 Permission!!"
				echo "$i is Not 750 Permission!!" >> $RESULT_FILE 2>&1
		fi 
		else
			echo "$i is Not Exist"	
			echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-088	/etc/(x)inetd.conf 파일 소유자 및 권한 설정"
echo "SRV-088	/etc/(x)inetd.conf 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-088

result_tmp=0

for i in /etc/inetd.conf /etc/xinetd.conf 
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))

			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 600 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is `stat -c "%U" $i` Permission!!"
				echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-089	/etc/syslog.conf 파일 소유자 및 권한 설정"
echo "SRV-089	/etc/syslog.conf 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-089

result_tmp=0

for i in /etc/syslog.conf rsyslog.conf
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))

			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 644 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is `stat -c "%U" $i` Permission!!"
				echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-091	SUID, SGID, Sticky bit 설정 파일 점검"
echo "SRV-091	SUID, SGID, Sticky bit 설정 파일 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-091

result_tmp=0

for i in /sbin/dump /usr/bin/lpq-lpd /usr/bin/newgrp /sbin/restore /usr/bin/lpr /usr/sbin/lpc /sbin/unix_chkpwd /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bin/at /usr/bin/lprm /usr/sbin/traceroute /usr/bin/lpq /usr/bin/lprm-lpddo
do
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ `stat -c "%a" $i` -le 1000 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is `stat -c "%a" $i` Permission!!"
			echo "$i is `stat -c "%a" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-092	홈 디렉토리 소유자 및 권한 설정"
echo "SRV-092	홈 디렉토리 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-092

result_tmp=0

for i in `cat /etc/passwd |egrep -v 'adm|lp|sync|halt|news|uucp|shutdown|games|operator|gopher|usbmuxd|squid|rtkit|abrt|nfsnobody|ricci|avahi-autoipd|pulse|nologin' |awk -F : '{print $6}'`
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ `stat -c "%a" $i|xargs -i expr substr {} 3 1` -gt 0 ]
		then
			RST_CODE=Fail
			echo "$i is other permission : `stat -c "%a" $i` "
			echo "$i is other permission : `stat -c "%a" $i` " >> $RESULT_FILE 2>&1
		else
			RST_CODE=Pass
		fi
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-093	world writable 파일 점검"
echo "SRV-093	world writable 파일 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-093

result_tmp=0

for i in  /home /export/home /etc /bin /sbin /usr/bin /usr/sbin /usr/etc /usr/ucb /usr/ccs/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/openwin/bin /usr/X/bin /usr/sfw/sbin /tmp /var
do
  if [ -d  $i ]
  then
 		for j in `ls -lL "$i" |grep ^-|awk '{print $9}'`
	  do
   		if [ "`ls -lL $i/$j |xargs -i expr substr {} 9 1`" == "-" ]
 			then
   	  	result_tmp=$(($result_tmp+0))
     	else
        result_tmp=$(($result_tmp+1))
        echo "$i/$j is other write permission!!"  >> $RESULT_FILE 2>&1
      fi
    done
  else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-094	Crontab 참조파일 권한 설정 오류"
echo "SRV-094	Crontab 참조파일 권한 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-094

result_tmp=0

for i in  /var/spool/cron /etc/cron.daily /etc/cron.weekly /etc/cron.monthly 
do
  if [ -d  $i ]
  then
 		for j in `ls -lL "$i" |grep ^-|awk '{print $9}'`
	  do
   		if [ "`ls -lL $i/$j |xargs -i expr substr {} 9 1`" == "-" ]
 			then
  	  	result_tmp=$(($result_tmp+0))
     	else
        result_tmp=$(($result_tmp+1))
        echo "$i is other write permission!!"  >> $RESULT_FILE 2>&1
     	fi
    done
   else
    	echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
    fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-095	파일 및 디렉토리 소유자 설정"
echo "SRV-095	파일 및 디렉토리 소유자 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-095

result_tmp=0

for i in  /tmp /home /export/home
do
  if [ -d $i ]
	then	
		if [ `find $i \( -nouser -o -nogroup \) -exec ls -ldL {} \;|wc -l` -gt 0 ]
  	then
 			find $i \( -nouser -o -nogroup \) -exec ls -ldL {} \; >> $RESULT_FILE 2>&1
			result_tmp=$(($result_tmp+1))
    else
      result_tmp=$(($result_tmp+0))
    fi
	else
		echo "$i is not Exist"
		echo "$i is not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-096	사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정"
echo "SRV-096	사용자, 시스템 시작파일 및 환경파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-096

result_tmp=0
for i in `cat /etc/passwd |egrep -v 'adm|lp|sync|halt|news|uucp|shutdown|games|operator|gopher|usbmuxd|squid|rtkit|abrt|nfsnobody|ricci|avahi-autoipd|pulse|nologin' |awk -F : '{print $6}'`
do
	for j in `ls -al |egrep '.profile|.kshrc|.cshrc|.bashrc|.bash_profile|.login|.exrc|.netrc' |awk '{print $9}'`
	do 
		if [ -e $i/$j ]
		then 
		  if [ "`ls -lL $i/$j |xargs -i expr substr {} 9 1`" == "-" ]
    	then
     		result_tmp=$(($result_tmp+0))
    	else
      	result_tmp=$(($result_tmp+1))
      	echo "$i/$j is other write permission!!"  >> $RESULT_FILE 2>&1
    	fi
		else
			echo "$i/$j is Not Exist"  >> $RESULT_FILE 2>&1
		fi
	done
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-099	/etc/services 파일 소유자 및 권한 설정"
echo "SRV-099	/etc/services 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-099

result_tmp=0
for i in /etc/services
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))

			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 644 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is `stat -c "%U" $i` Permission!!"
				echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-100	xterm 실행 파일 권한 설정"
echo "SRV-100	xterm 실행 파일 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-100

result_tmp=0
for i in /usr/bin/xterm /usr/bin/X11/xterm /usr/lpp/X11/bin/xterm /usr/openwin/bin/xterm
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 600 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is `stat -c "%U" $i` Permission!!"
				echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-106	hosts.lpd 파일 소유자 및 권한 설정"
echo "SRV-106	hosts.lpd 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-106

result_tmp=0
for i in /etc/hosts.lpd
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 600 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is `stat -c "%U" $i` Permission!!"
			echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-107	at 접근제한 파일 소유자 및 권한 설정"
echo "SRV-107	at 접근제한 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-107

result_tmp=0
for i in /etc/at.allow /etc/at.deny
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 640 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is `stat -c "%a" $i` Permission!!"
			echo "$i is `stat -c "%a" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-108	과도한 시스템 로그파일 권한 설정"
echo "SRV-108	과도한 시스템 로그파일 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-108

result_tmp=0
for i in /etc/syslog.conf /etc/rsyslog.conf
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 644 ]
			then
				result_tmp=$(($result_tmp+0))
			else
				result_tmp=$(($result_tmp+1))
				echo "$i is `stat -c "%U" $i` Permission!!"
				echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-112	Cron 서비스 실행 로깅 미설정"
echo "SRV-112	Cron 서비스 실행 로깅 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-112

if [ `grep ^cron.* /etc/rsyslog.conf|wc -l` -gt 0 ]
then
  RST_CODE=Pass
else
	RST_CODE=Fail
	echo "cron log not config"	
	echo "cron log not config" >> $RESULT_FILE 2>&1
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-114	로그인 실패 감사 기능 미설정"
echo "SRV-114	로그인 실패 감사 기능 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-114


result_tmp=0
for i in /var/log/btmp
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -eq 600 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is `stat -c "%U" $i` Permission!!"
			echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1


echo "SRV-115	로그의 정기적 검토 및 보고"
echo "SRV-115	로그의 정기적 검토 및 보고"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-115

RST_CODE=Check

echo "해당 내용은 보안 정책에 따른 내용으로 별도 확인 필요"
echo "해당 내용은 보안 정책에 따른 내용으로 별도 확인 필요" >> $RESULT_FILE 2>&1

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-118	최신 보안패치 및 벤더 권고사항 적용"
echo "SRV-118	최신 보안패치 및 벤더 권고사항 적용"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-118

RST_CODE=Check

echo "해당 내용은 보안 정책에 따른 내용으로 별도 확인 필요"
echo "해당 내용은 보안 정책에 따른 내용으로 별도 확인 필요" >> $RESULT_FILE 2>&1

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1


echo "SRV-121	root 홈, 패스 디렉토리 권한 및 패스 설정"
echo "SRV-121	root 홈, 패스 디렉토리 권한 및 패스 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-121

result_tmp=0

for i in `cat /etc/passwd |egrep -v 'adm|lp|sync|halt|news|uucp|shutdown|games|operator|gopher|usbmuxd|squid|rtkit|abrt|nfsnobody|ricci|avahi-autoipd|pulse|nologin' |awk -F : '{print $6}'`
do
  if [ -d  $i ]
  then
 		for j in .profile .bash_profile .cshrc .kshrc .bashrc
	  do
   		if [ -e $i/$j ]
 			then
				if [ `grep "::" $i/$j|grep PATH|wc -l` -eq 0 ]
				then
 	  			result_tmp=$(($result_tmp+0))
				elif [ `grep "\." $i/$j|grep PATH|wc -l` -eq 0 ]
				then
					result_tmp=$(($result_tmp+0))
				else
					result_tmp=$(($result_tmp+1))
					echo "$i/$j PATH Configured '.' or '::'"
					echo "$i/$j PATH Configured '.' or '::'"  >> $RESULT_FILE 2>&1
				fi
     	else
        echo "$i/$j is Not Exist"
				echo "$i/$j is Not Exist"  >> $RESULT_FILE 2>&1
      fi
    done
  else
    echo "$i is Not Exist"
		echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ `grep "::" /etc/profile|grep PATH|wc -l` -gt 0 ]
then
	result_tmp=$(($result_tmp+1))
elif [ `grep "\." /etc/profile|grep PATH|wc -l` -gt 0 ]
then
	result_tmp=$(($result_tmp+1))
else
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-122	관리자 UMASK 설정 오류"
echo "SRV-122	관리자 UMASK 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-122

result_tmp=0

for i in `cat /etc/passwd |egrep -v 'adm|lp|sync|halt|news|uucp|shutdown|games|operator|gopher|usbmuxd|squid|rtkit|abrt|nfsnobody|ricci|avahi-autoipd|pulse|nologin' |awk -F : '{print $6}'`
do
  if [ -d  $i ]
  then
  	for j in .profile .bash_profile .cshrc .kshrc .bashrc
		do
    	if [ -e $i/$j ]
    	then
				if [ `grep "umask [0-9]" /etc/profile |tail -1|awk '{print $2}'` -lt 027 ]
				then
     			result_tmp=$(($result_tmp+1))
					echo "$i/$j umask Configured `grep "umask [0-9]" /etc/profile |tail -1`"
					echo "$i/$j umask Configured `grep "umask [0-9]" /etc/profile |tail -1`"  >> $RESULT_FILE 2>&1
				else
					result_tmp=$(($result_tmp+0))
				fi
     	else
        echo "$i/$j is Not Exist"
				echo "$i/$j is Not Exist"  >> $RESULT_FILE 2>&1
      fi
   	done
  else
    echo "$i is Not Exist"
		echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ `grep "umask [0-9]" /etc/profile |tail -1|awk '{print $2}'` -lt 027 ]
then
	result_tmp=$(($result_tmp+1))
else
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Except
else
	RST_CODE=Except
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-127	계정 잠금 임계값 설정"
echo "SRV-127	계정 잠금 임계값 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-127

result_tmp=0

if [ `cat /etc/pam.d/system-auth |grep retry |awk -F "retry=" '{print $2}'|awk '{print $1}'` -le 5 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/etc/pam.d/system-auth password retry : `cat /etc/pam.d/system-auth |grep retry `"
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-130	관리자 UMASK 설정 오류"
echo "SRV-130	관리자 UMASK 설정 오류"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-130

result_tmp=0

if [ `grep "UMASK" /etc/login.defs |tail -1|awk '{print $2}'` -lt 027 ]
then
	result_tmp=$(($result_tmp+1))
else
	result_tmp=$(($result_tmp+0))
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-131	SU 명령 사용가능 그룹 제한 미비"
echo "SRV-131	SU 명령 사용가능 그룹 제한 미비"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-131

result_tmp=0

if [ `stat -c "%a" /bin/su` -le 4750 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/bin/su permission is  `stat -c "%a" /bin/su`"
	echo "/bin/su permission is  `stat -c "%a" /bin/su`" >> $RESULT_FILE 2>&1
fi

if [ "`stat -c "%G" /bin/su`" == "wheel" ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "/bin/su group is  `stat -c "%G" /bin/su`"
	echo "/bin/su group is  `stat -c "%G" /bin/su`" >> $RESULT_FILE 2>&1
fi

if [ `grep "^auth" /etc/pam.d/su|grep required|grep "pam_wheel.so use_uid"|wc -l` -gt 0  ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "No pam_wheel.so Config!!"
	echo "No pam_wheel.so Config!!" >> $RESULT_FILE 2>&1
fi

if [ `grep "wheel" /etc/group |wc -l` -gt 0  ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo "wheel Group is Not Exist!!"
	echo "wheel Group is Not Exist!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-132	cron 파일 소유자 및 권한 설정"
echo "SRV-132	cron 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-132

result_tmp=0

for i in  /etc/cron.allow /etc/cron.deny
do
  if [ -e  $i ]
  then
		if [ "`ls -lL $i|xargs -i expr substr {} 9 1`" == "-" ]
  	then
    	result_tmp=$(($result_tmp+0))
   	else
      result_tmp=$(($result_tmp+1))
      echo "$i is other write permission!!"
			echo "$i is other write permission!!"  >> $RESULT_FILE 2>&1
   	fi

   	if [ "`stat -c "%U" $i`" == "root" ]
 		then
 	  	result_tmp=$(($result_tmp+0))
   	else
      result_tmp=$(($result_tmp+1))
      echo "$i is not `stat -c "%U" $i` owner!!"
			echo "$i is not `stat -c "%U" $i` owner!!"  >> $RESULT_FILE 2>&1
    fi
		echo "------------------------------------------------------------"
		echo "------------------------------------------------------------" >> $RESULT_FILE 2>&1
		echo `cat $i`
		echo `cat $i`  >> $RESULT_FILE 2>&1
		echo "------------------------------------------------------------"
		echo "------------------------------------------------------------" >> $RESULT_FILE 2>&1
		
	else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi


# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-133	cron 파일 소유자 및 권한 설정"
echo "SRV-133	cron 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-133

result_tmp=0

for i in  /etc/cron.allow
do
  if [ -e  $i ]
  then
		if [ `cat $i|wc -l` -gt 0 ]
   	then
     	result_tmp=$(($result_tmp+0))
			echo "Cron Allow User"
			echo "Cron Allow User" >> $RESULT_FILE 2>&1
			cat $i 
			cat $i >> $RESULT_FILE 2>&1
			echo "----------------------------------------------------------"
			echo "----------------------------------------------------------" >> $RESULT_FILE 2>&1
   	else
      result_tmp=$(($result_tmp+0))
      echo "only root user allow crontab"
			echo "only root user allow crontab"  >> $RESULT_FILE 2>&1
    fi
	else
		result_tmp=$(($result_tmp+1))
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-134	cron 스택 영역 실행 방지 미설정"
echo "SRV-134	cron 스택 영역 실행 방지 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-134

RST_CODE=Pass

echo "해당 항목은 Linux OS 취약점 내용이 아님"
echo "해당 항목은 Linux OS 취약점 내용이 아님" >> $RESULT_FILE 2>&1

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-135	TCP ISS 설정 여부"
echo "SRV-135	TCP ISS 설정 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-135

RST_CODE=Pass

echo "해당 항목은 Linux OS 취약점 내용이 아님"
echo "해당 항목은 Linux OS 취약점 내용이 아님" >> $RESULT_FILE 2>&1

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-142	root 계정과 동일한 UID 금지"
echo "SRV-142	root 계정과 동일한 UID 금지"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-142

result_tmp=0

for i in  /etc/passwd
do
  if [ -e  $i ]
  then
		if [ `cat $i |grep x\:0 |grep -v root|wc -l` -eq 0 ]
   	then
     	result_tmp=$(($result_tmp+0))
   	else
      result_tmp=$(($result_tmp+1))
      echo "`cat $i |grep x\:0 |grep -v root` is root uid(0)"
			echo "`cat $i |grep x\:0 |grep -v root` is root uid(0)" >> $RESULT_FILE 2>&1
    fi
	else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-143	일반 계정과 동일한 UID 금지"
echo "SRV-143	일반 계정과 동일한 UID 금지"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-143

result_tmp=0

for i in  /etc/passwd
do
  if [ -e  $i ]
  then
 		if [ `cat /etc/passwd |awk -F : '{print $3}'|uniq -d|wc -l` -eq 0 ]
   	then
     	result_tmp=$(($result_tmp+0))
   	else
      result_tmp=$(($result_tmp+1))
      echo "`cat /etc/passwd |awk -F : '{print $3}'|uniq -d` is duplicate uid!!"
			echo "`cat /etc/passwd |awk -F : '{print $3}'|uniq -d` is duplicate uid!!" >> $RESULT_FILE 2>&1
    fi
	else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-144	/dev에 존재하지 않는 device 파일 점검"
echo "SRV-144 /dev에 존재하지 않는 device 파일 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-144
 
result_tmp=0

if [ `find /dev -type f -exec ls -l {} \; |grep -v /dev/shm|grep -v /dev/.udev/|grep -v /dev/odm|wc -l` -eq 0 ]
then
 	result_tmp=$(($result_tmp+0))
else
  result_tmp=$(($result_tmp+1))
  echo "`find /dev -type f -exec ls -l {} \; |grep -v /dev/shm|grep -v /dev/.udev/|grep -v /dev/odm` is Exist!!"
	echo "`find /dev -type f -exec ls -l {} \; |grep -v /dev/shm|grep -v /dev/.udev/|grep -v /dev/odm` is Exist!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-145	홈디렉토리로 지정한 디렉토리의 존재 관리"
echo "SRV-145	홈디렉토리로 지정한 디렉토리의 존재 관리"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-145

result_tmp=0

if [ `cat /etc/passwd |egrep -v 'nologin|false' |awk -F : '{print $6}'|uniq |xargs file|grep "cannot open"|wc -l` -eq 0 ]
then
 	result_tmp=$(($result_tmp+0))
else
  result_tmp=$(($result_tmp+1))
  echo "`cat /etc/passwd |awk -F : '{print $6}'|uniq |xargs file|grep "cannot open"|awk '{print $1}'` is Not Exist!!"
	echo "`cat /etc/passwd |awk -F : '{print $6}'|uniq |xargs file|grep "cannot open"|awk '{print $1}'` is Not Exist!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-146	ftp 계정 shell 제한"
echo "SRV-146	ftp 계정 shell 제한"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-146

result_tmp=0

if [ `cat /etc/passwd  |grep ftp|wc -l` -eq 0 ]
then
 	result_tmp=$(($result_tmp+0))
else
  if [ `cat /etc/passwd|grep ftp|egrep 'false|nologin'|wc -l` -gt 0 ]
	then
		result_tmp=$(($result_tmp+0))
	else
		result_tmp=$(($result_tmp+1))
		echo "FTP User Shell is Not False or nologin!!"
		echo "FTP User Shell is Not False or nologin!!" >> $RESULT_FILE 2>&1
	fi
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-147	SNMP 서비스 구동 점검"
echo "SRV-147	SNMP 서비스 구동 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-147

result_tmp=0

OS_TYPE=`cat /etc/system-release |awk '{print $1}'`

case $OS_TYPE in
	CentOS)
		if [ `systemctl list-unit-files |grep -i snmp|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no SNMP Service!!"
		else
			result_tmp=$(($result_tmp+1))
			echo "There is SNMP Service!!"
			echo "There is SNMP Service!!"  >> $RESULT_FILE 2>&1
		fi
	;;
	Red)
		if [ `chkconfig --list |grep -i snmp|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no SNMP Service!!"
		else
			result_tmp=$(($result_tmp+1))
			echo "There is SNMP Service!!"
			echo "There is SNMP Service!!"  >> $RESULT_FILE 2>&1
		fi
	;;
	*)
		echo "No CentOS or Red Hat Linux"
		echo "No CentOS or Red Hat Linux" >> $RESULT_FILE 2>&1
esac

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-148	Apache 웹서비스 정보 숨김"
echo "SRV-148	Apache 웹서비스 정보 숨김"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-148

result_tmp=0

for i in `ps -ef |grep httpd |grep conf |awk '{print $12}'|uniq`
do
  if [ -e  $i ]
  then
 		if [ "`grep ServerTokens $i |awk '{print $2}'`" == "Prod" ]
   	then
     	result_tmp=$(($result_tmp+0))
   	else
      result_tmp=$(($result_tmp+1))
      echo "$i ServerToken Config Modify Requred!!"
			echo "$i ServerToken Config Modify Requred!!" >> $RESULT_FILE 2>&1
    fi
	else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-158	불필요한 TELNET 서비스 구동 여부"
echo "SRV-158	불필요한 TELNET 서비스 구동 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-158

result_tmp=0

OS_TYPE=`cat /etc/system-release |awk '{print $1}'`

case $OS_TYPE in
	CentOS)
		if [ `systemctl list-unit-files |grep -i telnet|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no Telnet Service!!"
		else
			result_tmp=$(($result_tmp+1))
			echo "There is Telnet Service!!"
			echo "There is Telnet Service!!"  >> $RESULT_FILE 2>&1
		fi
	;;
	Red)
		if [ `chkconfig --list |grep -i telnet|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no Telnet Service!!"
		else
			result_tmp=$(($result_tmp+1))
			echo "There is Telnet Service!!"
			echo "There is Telnet Service!!"  >> $RESULT_FILE 2>&1
		fi
	;;
	*)
		echo "No CentOS or Red Hat Linux"
		echo "No CentOS or Red Hat Linux" >> $RESULT_FILE 2>&1
esac

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-159	원격 접속 세션 타임아웃 미설정"
echo "SRV-159	원격 접속 세션 타임아웃 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-159

result_tmp=0

for i in  /etc/profile /etc/bashrc
do
  if [ -e  $i ]
  then
 		if [ `cat $i |grep TIMEOUT|awk -F = '{print $2}'|wc -l` -gt 0 ]
   	then
			if [ `cat $i |grep TIMEOUT|awk -F = '{print $2}'` -le 300 ]
			then
			 	result_tmp=$(($result_tmp+0))
			else
			  result_tmp=$(($result_tmp+1))
				echo "$i Config TIMEOUT Under 300"
				echo "$i Config TIMEOUT Under 300" >> $RESULT_FILE 2>&1
			fi
		else
			echo "$i is No TIMEOUT Config!!"
			echo "$i is No TIMEOUT Config!!" >> $RESULT_FILE 2>&1
    fi
	else
    echo "$i is Not Exist"  >> $RESULT_FILE 2>&1
  fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-160	불필요한 계정 및 사용하지 않는 계정 존재 여부"
echo "SRV-160	불필요한 계정 및 사용하지 않는 계정 존재 여부"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-160

result_tmp=0

if [ `cat /etc/passwd |egrep '^adm|^lp|^sync|^shutdown|^halt|^news|^uucp|^operator|^games|^gopher|^nfsnobody|^squid'|egrep -v 'nologin|false'|wc -l` -eq 0 ]
then
 	result_tmp=$(($result_tmp+0))
else
  result_tmp=$(($result_tmp+1))
	echo "There is No Necessary Account!!"
	echo "There is No Necessary Account!!" >> $RESULT_FILE 2>&1
	echo "----------------------------------------------------------------"
	echo "----------------------------------------------------------------">> $RESULT_FILE 2>&1
	echo `cat /etc/passwd |egrep '^adm|^lp|^sync|^shutdown|^halt|^news|^uucp|^operator|^games|^gopher|^nfsnobody|^squid'|egrep -v 'nologin|false'`
	echo `cat /etc/passwd |egrep '^adm|^lp|^sync|^shutdown|^halt|^news|^uucp|^operator|^games|^gopher|^nfsnobody|^squid'|egrep -v 'nologin|false'` >> $RESULT_FILE 2>&1
	echo "----------------------------------------------------------------"
	echo "----------------------------------------------------------------">> $RESULT_FILE 2>&1
fi

for i in `lastlog -b 90|awk '{print $1}'|egrep -v 'Username|root'`
do
  if [ `cat /etc/passwd|grep ^$i|egrep -v 'nologin|false'|wc -l` -eq 0 ]
  then
 	  result_tmp=$(($result_tmp+0))
	else
  	result_tmp=$(($result_tmp+1))
		echo "There is No Login Account in resently 90Day!!"
		echo "There is No Login Account in resently 90Day!!" >> $RESULT_FILE 2>&1
		echo "----------------------------------------------------------------"
		echo "----------------------------------------------------------------" >> $RESULT_FILE 2>&1
		echo `cat /etc/passwd|grep ^$i|egrep -v 'nologin|false'`
		echo `cat /etc/passwd|grep ^$i|egrep -v 'nologin|false'` >> $RESULT_FILE 2>&1
		echo "----------------------------------------------------------------"
		echo "----------------------------------------------------------------" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Except
else
	RST_CODE=Except
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-161	Ftpusers 파일 소유자 및 권한 설정"
echo "SRV-161	Ftpusers 파일 소유자 및 권한 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-161

result_tmp=0

for i in `find /etc \( -name *ftpusers* -o -name *userlist* -o -name *user_list* \)`
do 
  if [ -L $i ]
	then
		echo "$i is Symbolic Link"
		echo "$i is Symbolic Link"  >> $RESULT_FILE 2>&1
	elif [ -e  $i ]
  then 
		if [ "`stat -c "%U" $i`" == "root" ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is owner is `stat -c "%U" $i`"
			echo "$i is owner is `stat -c "%U" $i`" >> $RESULT_FILE 2>&1
		fi 

		if [ `stat -c "%a" $i` -le 640 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i is `stat -c "%U" $i` Permission!!"
			echo "$i is `stat -c "%U" $i` Permission!!" >> $RESULT_FILE 2>&1
		fi 
	else
		echo "$i is Not Exist"	
		echo "$i is Not Exist" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-162	이벤트 로그에 대한 접근 권한 설정 미비"
echo "SRV-162	이벤트 로그에 대한 접근 권한 설정 미비"  >> $RESULT_FILE 2>&1
# 해당 로그는 /var/log/secure 에 통합되어 있음

SVR_CODE=SRV-162

result_tmp=0

if [ `stat -c "%g" /var/log/secure` -eq 0 ]
then
		result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
  echo " /var/log/secure is group is not root!!"
	echo " /var/log/secure is group is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%u"  /var/log/secure` -eq 0 ]
then
		result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo " /var/log/secure is owner is not root!!"
  echo " /var/log/secure is owner is not root!!" >> $RESULT_FILE 2>&1
fi 

if [ `stat -c "%a"  /var/log/secure` -le 640 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+1))
	echo " /var/log/secure is  `stat -c "%a"  /var/log/secure` Permission!!"
  echo " /var/log/secure is  `stat -c "%a"  /var/log/secure` Permission!!" >> $RESULT_FILE 2>&1
fi 

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi 

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-163	원격 접속 세션 타임아웃 미설정"
echo "SRV-163	원격 접속 세션 타임아웃 미설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-163

result_tmp=0

OS_TYPE=`cat /etc/system-release |awk '{print $1}'`

case $OS_TYPE in
	CentOS)
		if [ `systemctl list-unit-files |grep -i telnet|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no Telnet Service!!"
			echo "There is no Telnet Service!!" >> $RESULT_FILE 2>&1
		else
			if [ `cat /etc/motd|wc -l` -eq 0 ]
			then
				result_tmp=$(($result_tmp+1))
				echo "There is Telnet Service and No Banner!!"
				echo "There is Telnet Service and No Banner!!" >> $RESULT_FILE 2>&1
			else
				echo "Telnet Banner is"
				echo "-------------------------------------------"
				echo `cat /etc/motd`
				echo "-------------------------------------------"
				echo "Telnet Banner is" >> $RESULT_FILE 2>&1
				echo "-------------------------------------------" >> $RESULT_FILE 2>&1
				echo `cat /etc/motd` >> $RESULT_FILE 2>&1
				echo "-------------------------------------------" >> $RESULT_FILE 2>&1
			fi
		fi
	;;
	Red)
		if [ `chkconfig --list |grep -i telnet|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
			echo "There is no Telnet Service!!"
		else
			if [ `cat /etc/motd|wc -l` -eq 0 ]
			then
				result_tmp=$(($result_tmp+1))
				echo "There is Telnet Service and No Banner!!"
				echo "There is Telnet Service and No Banner!!" >> $RESULT_FILE 2>&1
			else
				echo "Telnet Banner is"
				echo "-------------------------------------------"
				echo `cat /etc/motd`
				echo "-------------------------------------------"
				echo "Telnet Banner is" >> $RESULT_FILE 2>&1
				echo "-------------------------------------------" >> $RESULT_FILE 2>&1
				echo `cat /etc/motd` >> $RESULT_FILE 2>&1
				echo "-------------------------------------------" >> $RESULT_FILE 2>&1
			fi
		fi
	;;
	*)
		echo "No CentOS or Red Hat Linux"
		echo "No CentOS or Red Hat Linux" >> $RESULT_FILE 2>&1
esac

if [ "`cat /etc/ssh/sshd_config |grep Banner|awk '{print $2}'`" == "none" ]
then
	result_tmp=$(($result_tmp+1))
	echo "SSH Service No Banner!!"
	echo "SSH Service No Banner!!" >> $RESULT_FILE 2>&1
else
	echo "SSH Service Banner"
	echo "`cat /etc/ssh/sshd_config |grep Banner|awk '{print $2}'`"
	echo "SSH Service Banner" >> $RESULT_FILE 2>&1
	echo "`cat /etc/ssh/sshd_config |grep Banner|awk '{print $2}'`" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-164	계정이 존재하지 않는 GID 금지"
echo "SRV-164	계정이 존재하지 않는 GID 금지" >> $RESULT_FILE 2>&1
SVR_CODE=SRV-164

result_tmp=0

for i in `cat /etc/group|awk -F : '{print $3}'`
do
	if [ `grep \:$i\: /etc/passwd|egrep -v 'wheel|operator'|wc -l` -gt 0 ]
	then
		result_tmp=$(($result_tmp+0))
	else
		result_tmp=$(($result_tmp+1))
		echo "`grep \:$i\: /etc/group|awk -F : '{print $1}'` is not exist in /etc/passwd"
		echo "`grep \:$i\: /etc/group|awk -F : '{print $1}'` is not exist in /etc/passwd" >> $RESULT_FILE 2>&1
	fi
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Except
else
	RST_CODE=Except
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-165	사용자 shell 점검"
echo "SRV-165	사용자 shell 점검"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-165

result_tmp=0

if [ `cat /etc/passwd |egrep '^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher'|egrep -v 'nologin|false'|wc -l` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	result_tmp=$(($result_tmp+2))
	echo "No Login account is"
	echo `cat /etc/passwd |egrep '^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher'|egrep -v 'nologin|false'`
	echo "No Login account is" >> $RESULT_FILE 2>&1
	echo `cat /etc/passwd |egrep '^daemon|^bin|^sys|^adm|^listen|^nobody|^nobody4|^noaccess|^diag|^listen|^operator|^games|^gopher'|egrep -v 'nologin|false'` >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-166	숨겨진 파일 및 디렉토리 검색 및 제거"
echo "SRV-166	숨겨진 파일 및 디렉토리 검색 및 제거"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-166

result_tmp=0

for i in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /dev /devices
do
	if [ -d $i ]
	then
		if [ `find $i -name ".*"|wc -l` -eq 0 ]
		then
			result_tmp=$(($result_tmp+0))
		else
			result_tmp=$(($result_tmp+1))
			echo "$i in hidden file!!"
			find $i -name ".*"  >> $RESULT_FILE 2>&1
			echo "$i in hidden file!!" >> $RESULT_FILE 2>&1
		fi
	fi 
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
	find -name ".*" >> $RESULT_FILE 2>&1
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-167	ftp 서비스 확인"
echo "SRV-167	ftp 서비스 확인"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-167

result_tmp=0

if [ `netstat -na |grep "LISTEN"|grep "\:21"|wc -l` -eq 0 ]
then
	result_tmp=$(($result_tmp+0))
else
	echo "FTP Service Port is Listening!!"
	echo "FTP Service Port is Listening!!" >> $RESULT_FILE 2>&1
fi

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

echo "SRV-168	정책에 따른 시스템 로깅 설정"
echo "SRV-168 정책에 따른 시스템 로깅 설정"  >> $RESULT_FILE 2>&1
SVR_CODE=SRV-168

result_tmp=0

for i in /var/log/message /var/log/secure /var/log/maillog /var/log/cron /var/log/boot.log \*.emerg
do
	if [ `cat /etc/rsyslog.conf|grep $i|grep ^\#|wc -l` -eq 0 ]
	then
		result_tmp=$(($result_tmp+0))
	else
		result_tmp=$(($result_tmp+1))
		echo "$i is not config in /etc/rsyslog.conf"
		echo "$i is not config in /etc/rsyslog.conf" >> $RESULT_FILE 2>&1
	fi 
done

if [ $result_tmp -eq 0 ]
then
	RST_CODE=Pass
else
	RST_CODE=Fail
fi

# 결과 정리
echo "[Result_Summary] : $SVR_CODE : $RST_CODE"
echo "[Result_Summary] : $SVR_CODE : $RST_CODE" >> $RESULT_FILE 2>&1
echo "================================================================"
echo "================================================================" >> $RESULT_FILE 2>&1

# Check Summary File 
echo $HOSTNAME > $HOSTNAME-linux-result-`date +%F`_sum.txt
grep "Result_" $RESULT_FILE |awk '{print $5}' >> $HOSTNAME-linux-result-`date +%F`_sum.txt
