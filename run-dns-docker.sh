#!/bin/sh

IMAGE="phensley/docker-dns:latest"
NAME="dns"
NETWORK=ci
NETWORK_IP=172.18.0
IP=${NETWORK_IP}.53
DOCKER_BRIDGE_GATEWAY=172.23.0.1
#DOCKER_BRIDGE_GATEWAY=172.17.0.1
#DOCKER_BRIDGE_GATEWAY=172.24.0.1

RUNNING=`docker ps | grep -c $NAME`
if [ $RUNNING -gt 0 ]
then
   echo "Stopping $NAME"
   docker stop $NAME
fi

EXISTING=`docker ps -a | grep -c $NAME`
if [ $EXISTING -gt 0 ]
then
   echo "Removing $NAME"
  docker rm $NAME
fi

echo "Create new instance $NAME based on $IMAGE"
docker pull $IMAGE
docker run \
	--name $NAME \
    -v /var/run/docker.sock:/docker.sock \
    -d $IMAGE \
    --domain docker
#	-p ${DOCKER_BRIDGE_GATEWAY}:53:53/udp \
#	-v /var/run/docker.sock:/docker.sock \
#	-d $IMAGE \
#	--domain docker

echo "Tail the logs of the new instance"
sleep 10
docker logs $NAME
