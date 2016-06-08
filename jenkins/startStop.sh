#!/bin/bash
# #1 config file
CONFIG=$1
. ./config/defaults.conf
if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR][Jenkins2][start-stop] No $CONFIG found, exiting ..."
   exit 1
fi

ACTION=$2
for i in $(seq 1 $JENKINS_SLAVES)
do
  docker $ACTION "${JENKINS_SLAVE_CONTAINER_BASE}$i"  >> cow.log 2>&1
  RUNNING=`docker ps | grep -c ${JENKINS_SLAVE_CONTAINER_BASE}$i`
  if [ $RUNNING -gt 0 ]
  then
     echo "[CoW][INFO][Jenkins2][start-stop] ${JENKINS_SLAVE_CONTAINER_BASE}$i is up"
  else
     echo "[CoW][INFO][Jenkins2][start-stop] ${JENKINS_SLAVE_CONTAINER_BASE}$i is down"
  fi
done

docker $ACTION $JENKINS_CONTAINER  >> cow.log 2>&1
RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2][start-stop] $JENKINS_CONTAINER is up"
else
   echo "[CoW][INFO][Jenkins2][start-stop] $JENKINS_CONTAINER is down"
fi
sleep 15
docker $ACTION $JENKINS_PROXY_CONTAINER  >> cow.log 2>&1
sleep 5
RUNNING=`docker ps | grep -c $JENKINS_PROXY_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2][start-stop] $JENKINS_PROXY_CONTAINER is up"
else
   echo "[CoW][INFO][Jenkins2][start-stop] $JENKINS_PROXY_CONTAINER is down"
fi
