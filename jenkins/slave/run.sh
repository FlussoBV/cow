#!/bin/bash
#1 network, 2 image, 3 name, 4 number

NETWORK_DEFAULT="ci"
NETWORK="${1:-$NETWORK_DEFAULT}"

IMAGE_DEFAULT="jenkins-slave-image"
IMAGE="${2:-$IMAGE_DEFAULT}"

BASE_NAME_DEFAULT="jenkins-slave-instance"
BASE_NAME="${3:-$IMAGE_DEFAULT}"

NAME_NUMBER_DEFAULT="1"
NAME_NUMBER="${4:-$NAME_NUMBER_DEFAULT}"
NAME="${BASE_NAME}${NAME_NUMBER}"

RUNNING=`docker ps | grep -c $NAME`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-slave][run] Stopping $NAME"
   docker stop $NAME  >> cow.log 2>&1
fi

EXISTING=`docker ps -a | grep -c $NAME`
if [ $EXISTING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-slave][run] Removing $NAME"
  docker rm $NAME  >> cow.log 2>&1
fi

echo "[CoW][INFO][Jenkins2-slave][run] Running $NAME based on $IMAGE"
docker run --name=$NAME --net=$NETWORK --net-alias=$NAME -d $IMAGE  >> cow.log 2>&1

# --dns $(docker inspect -f '{{.NetworkSettings.IPAddress}}' dns) \

echo "[CoW][INFO][Jenkins2-slave][run] Tail the logs of the new instance" >> cow.log 2>&1
sleep 10
docker logs $NAME  >> cow.log 2>&1
RUNNING=`docker ps | grep -c $NAME`
if [ $RUNNING -gt 0 ]
then
   echo "[CoW][INFO][Jenkins2-slave][run] $NAME is up"
else
   echo "[CoW][INFO][Jenkins2-slave][run] $NAME is down"
fi
