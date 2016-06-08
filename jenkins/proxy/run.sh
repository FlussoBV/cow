#!/bin/bash
#1 network, 2 image, 3 name

NETWORK_DEFAULT="ci"
NETWORK="${1:-$NETWORK_DEFAULT}"

IMAGE_DEFAULT="jenkins-proxy-image"
IMAGE="${2:-$IMAGE_DEFAULT}"

PROXY_NAME_DEFAULT="jenkins-proxy-instance"
PROXY_NAME="${3:-$PROXY_NAME_DEFAULT}"

RUNNING=`docker ps | grep -c $PROXY_NAME`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-proxy][run] Stopping $PROXY_NAME"
   docker stop $PROXY_NAME  >> cow.log 2>&1
fi

EXISTING=`docker ps -a | grep -c $PROXY_NAME`
if [ $EXISTING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-proxy][run] Removing $PROXY_NAME"
  docker rm $PROXY_NAME  >> cow.log 2>&1
fi

echo "[CoW][INFO][Jenkins2-proxy][run] Running $PROXY_NAME"
docker run --name $PROXY_NAME -d $IMAGE  >> cow.log 2>&1
docker network connect ${NETWORK} ${PROXY_NAME}  >> cow.log 2>&1
sleep 20
docker start ${PROXY_NAME}  >> cow.log 2>&1
sleep 5
RUNNING=`docker ps | grep -c $PROXY_NAME`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-proxy][run] $PROXY_NAME is up"
else
   echo "[CoW][INFO][Jenkins2-proxy][run] $PROXY_NAME is down"
fi
