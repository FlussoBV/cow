#!/bin/bash
#1=config, #2=service
CONFIG=$1
SERVICE=$2

. ./config/defaults.conf
if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR][main][init] No $CONFIG found, exiting ..."
   exit 1
fi

EXISTING=`docker network ls | grep -c $NETWORK`
if [ $EXISTING -gt 0 ]
then
  echo "[CoW][INFO][main][init]  Network $NETWORK already exists"
else
  echo "[CoW][INFO][main][init]  Creating network $NETWORK"
  docker network create \
    --driver bridge \
    --subnet=$NETWORK_SUBNET \
    -o "com.docker.network.bridge.host_binding_ipv4"="$NETWORK_BIND_IP" \
    -o "com.docker.network.bridge.name"="$NETWORK" \
    $NETWORK
fi

echo "[CoW][INFO][main][init]  Initializing homedir ($HOMEDIR) "
case $SERVICE in
    jenkins )
    echo "[CoW][INFO][main][init]  Init Jenkins 2 "
	   ./jenkins/init.sh $CONFIG
	;;
    nexus )
    echo "[CoW][INFO][main][init]  Init Nexus 3 "
    ./nexus3/init.sh $CONFIG
	;;
    sonar )
    echo "[CoW][INFO][main][init]  Init SonarQube5 "
    ./sonarqube5/init.sh $CONFIG sonarqube5/
	;;
    * )
    echo "[CoW][INFO][main][init]  Init all [Jenkins 2, SonarQube 5, Nexus 3] "
    echo "[CoW][INFO][main][init]  Init Jenkins 2 "
    ./jenkins/init.sh $CONFIG
    echo "[CoW][INFO][main][init]  Init SonarQube5 "
    ./sonarqube5/init.sh $CONFIG sonarqube5/
    echo "[CoW][INFO][main][init]  Init Nexus 3 "
    ./nexus3/init.sh $CONFIG
	exit ;;
esac
