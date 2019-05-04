#!/bin/sh
# -------------------------------------------------------------
#   KHAN [provisioning]              http://www.opennaru.com/
#   JBoss EAP 6.4.0
#
#   contact : service@opennaru.com
#   Copyright(C) 2015, opennaru.com, All Rights Reserved.
# -------------------------------------------------------------

. ./env.sh

# -------------------------------------------------------------
#  CONNECTION POOL NAME
# -------------------------------------------------------------
read -p "> Enter the Connection Pool name : " DATASOURCE_NAME
read -p "> Enter the max pool size  : " MAX_POOL_SIZE

# -------------------------------------------------------------
#  maria Data Source Example
#
#  jndi-name, connection-url, username, password은 접속 환경에 맞게
#    수정하여 사용하십시오.
# -------------------------------------------------------------
export MARIA_DATASOURCE="
data-source add \\
--name=$DATASOURCE_NAME \\
--jndi-name=java:jboss/${DATASOURCE_NAME}_DBDS              \\
--allow-multiple-users=false \\
--background-validation=false \\
--blocking-timeout-wait-millis=60000 \\
--check-valid-connection-sql=select 1 \\
--connectable=false \\
--connection-url=jdbc:mariadb://127.0.0.1:4540/pfdsdb?useServerPrepStmts=false&autoReconnect=true \\
--driver-class=org.mariadb.jdbc.Driver \\
--driver-name=mariadb \\
--enabled=true \\
--exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter \\
--idle-timeout-minutes=15 \\
--jta=true \\
--max-pool-size=$MAX_POOL_SIZE \\
--min-pool-size=$MAX_POOL_SIZE \\
--pool-prefill=true \\
--pool-use-strict-min=true \\
--prepared-statements-cache-size=100 \\
--query-timeout=20 \\
--security-domain=FDS_PASSWORD \\
--set-tx-query-timeout=false \\
--share-prepared-statements=true \\
--spy=false \\
--statistics-enabled=true \\
--track-statements=nowarn \\
--use-ccm=true \\
--use-fast-fail=false \\
--use-java-context=true \\
--validate-on-match=true"

# -------------------------------------------------------------
#  MYSQL Data Source Example
#
#  jndi-name, connection-url, username, password은 접속 환경에 맞게
#    수정하여 사용하십시오.
# -------------------------------------------------------------
export MYSQL_DATASOURCE="
data-source add     \\
--name=$DATASOURCE_NAME                     \\
--jndi-name=java:jboss/datasources/abcDS    \\
--driver-name=mysql                         \\
--driver-class=com.mysql.jdbc.Driver        \\
--connection-url=jdbc:mysql://192.168.0.11:3306/test                \\
--min-pool-size=$MAX_POOL_SIZE              \\
--max-pool-size=$MAX_POOL_SIZE              \\
--pool-use-strict-min=true                  \\
--pool-prefill=true                         \\
--user-name=root                            \\
--password=passswd                          \\
--valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker \\
--validate-on-match=false                   \\
--background-validation=true                \\
--background-validation-millis=10000        \\
--exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter \\
--blocking-timeout-wait-millis=60000        \\
--idle-timeout-minutes=15                   \\
--track-statements=true                     \\
--prepared-statements-cache-size=300        \\
--share-prepared-statements=true"

# -------------------------------------------------------------
#  Oracle Data Source Example
#
#  jndi-name, connection-url, username, password은 접속 환경에 맞게
#    수정하여 사용하십시오.
# -------------------------------------------------------------
export ORACLE_DATASOURCE="
data-source add     \\
--name=$DATASOURCE_NAME                     \\
--jndi-name=java:jboss/datasources/abcdDS    \\
--driver-name=oracle                        \\
--driver-class=oracle.jdbc.OracleDriver     \\
--connection-url=jdbc:oracle:thin:@//192.168.0.11:1521/ORA           \\
--min-pool-size=$MAX_POOL_SIZE              \\
--max-pool-size=$MAX_POOL_SIZE              \\
--pool-use-strict-min=true                  \\
--pool-prefill=true                         \\
--user-name=root                            \\
--password=passswd                          \\
--valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleValidConnectionChecker \\
--stale-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleStaleConnectionChecker \\
--validate-on-match=false                   \\
--background-validation=true                \\
--background-validation-millis=10000        \\
--exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.oracle.OracleExceptionSorter \\
--blocking-timeout-wait-millis=60000        \\
--idle-timeout-minutes=15                   \\
--track-statements=true                     \\
--prepared-statements-cache-size=300        \\
--share-prepared-statements=true"



# 사용할 데이터 베이스를 선택하세요!!
# -------------------------------------------------------------
#  Data Source Select
# -------------------------------------------------------------
while true; do
    read -p "> Choose database . oracle(o), mysql(m), maria(a)? " db
    case $db in
        [Oo]* )
            export DATASOURCE=$ORACLE_DATASOURCE
            break;;
        [Mm]* )
            export DATASOURCE=$MYSQL_DATASOURCE
            break;;
        [Aa]* )
            export DATASOURCE=$MARIA_DATASOURCE
            break;;
        * ) echo "Enter o or m."; echo "";;

    esac
done

echo "-------------------------------------------------------------"
echo " 생성할 데이터소스 설정 정보 : "
echo "-------------------------------------------------------------"
echo "$DATASOURCE"
echo "-------------------------------------------------------------"

while true; do
    echo "* 데이터소스 설정을 변경하시려면 create-datasource.sh 스크립트 파일을 수정하십시오."
    read -p "> 위 설정으로 데이터 소스를 생성하시겠습니까(y/n)? " yn
    case $yn in
        [Yy]* )
            $JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$CONTROLLER_IP:$CONTROLLER_PORT --command="$DATASOURCE"
            $JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$CONTROLLER_IP:$CONTROLLER_PORT --command="data-source enable --name=$DATASOURCE_NAME"
            break;;
        [Nn]* ) exit;;
        * ) echo "y 나 n 를 입력하십시오."; echo "";;

    esac
done
