#!/bin/sh
# -------------------------------------------------------------
#   KHAN [provisioning]              http://www.opennaru.com/
#   JBoss EAP 6.4.0
#
#   contact : service@opennaru.com
#   Copyright(C) 2015, opennaru.com, All Rights Reserved.
# -------------------------------------------------------------

function getKhanAgentPath() {
 local KHAN_AGENT_PATH=$1

  for file in $(cat $KHAN_AGENT_PATH/current.version); do
    KHAN_AGENT_FILE="$file"
  done

  echo "$KHAN_AGENT_PATH/$KHAN_AGENT_FILE"
}

