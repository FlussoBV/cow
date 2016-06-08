#!/bin/bash
# 1 = config, 2 = context
. ./config/defaults.conf
CONFIG=$1
if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR][Jenkins2][init] No $CONFIG found, exiting ..."
   exit 1
fi
CONTEXT_LOCATION_DEFAULT=.
CONTEXT_LOCATION="${2:-$CONTEXT_LOCATION_DEFAULT}"

mkdir -p $HOMEDIR/$JENKINS_HOME_DIR
