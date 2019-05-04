#!/bin/sh
# -----------------------------------------------------------------------------
# Script to encrypt plain text using tomcat-jdbc-enc.jar
# -----------------------------------------------------------------------------
if [ "e$@" = "e" ]; then
  echo "Usage : ./encrypt.sh string-to-encrypt [string-secretkey]"
  echo "  - string-to-encrypt : essential"
  echo "  - string-secretkey : optional"
  echo "  - Ex : ./encrypt.sh ThisIsPassword ThisIsSecretKey"
else
  RESULT=`java -classpath /sw/tomcat/lib/tomcat-jdbc-enc.jar org.apache.tomcat.jdbc.pool.Encryptor "$@"`

  echo "InputText : `echo $RESULT | awk -F ':' '{print $1}'`"
  echo "Encrypted : `echo $RESULT | awk -F ':' '{print $2}'`"
fi
