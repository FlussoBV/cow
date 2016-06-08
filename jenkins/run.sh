#!/bin/bash
# 1 = config, 2 = context

. config/defaults.conf

CONFIG=$1
if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR][Jenkins2][run] No $CONFIG found, exiting ..."
   exit 1
fi

CONTEXT_LOCATION_DEFAULT=.
CONTEXT_LOCATION="${2:-$CONTEXT_LOCATION_DEFAULT}"

RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2][run] Stopping $JENKINS_CONTAINER"
   docker stop $JENKINS_CONTAINER  >> cow.log 2>&1
fi

EXISTING=`docker ps -a | grep -c $JENKINS_CONTAINER`
if [ $EXISTING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2][run] Removing $JENKINS_CONTAINER"
  docker rm $JENKINS_CONTAINER  >> cow.log 2>&1
fi

echo "[CoW][INFO][Jenkins2][run] Running $JENKINS_CONTAINER"
docker run --name $JENKINS_CONTAINER  \
  -v $HOMEDIR/$JENKINS_HOME_DIR:/var/jenkins_home \
  --net=$NETWORK --net-alias=$JENKINS_CONTAINER \
  -d $JENKINS_IMAGE  >> cow.log 2>&1

#--dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dns) \

echo "[CoW][INFO][Jenkins2][run] Tail the logs of the new instance" >> cow.log 2>&1
sleep 10
docker logs $JENKINS_CONTAINER  >> cow.log 2>&1
RUNNING=`docker ps | grep -c $JENKINS_CONTAINER`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2][run] $JENKINS_CONTAINER is up"
else
   echo "[CoW][INFO][Jenkins2][run] $JENKINS_CONTAINER is down"
fi


for i in $(seq 1 $JENKINS_SLAVES)
do
  echo "[CoW][INFO][Jenkins2][run] Running slave $i"
  ./${CONTEXT_LOCATION}slave/run.sh $NETWORK $JENKINS_SLAVE_IMAGE $JENKINS_SLAVE_CONTAINER_BASE $i
done

echo "[CoW][INFO][Jenkins2][run] Running proxy"
./${CONTEXT_LOCATION}proxy/run.sh $NETWORK $JENKINS_PROXY_IMAGE $JENKINS_PROXY_CONTAINER
