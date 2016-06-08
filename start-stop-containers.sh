#!/bin/bash
CONFIG=$1
CONTAINERS=$2
ACTION=$3

. ./config/defaults.conf

if [ "$ACTION" = "start" ]; then
  RUNNING=`docker ps | grep -c $SONARQUBE_CONTAINER`
  if [ "$RUNNING" = "0" ]; then
      docker start $DNS_NAME
  fi
fi

if [ -e $CONFIG ]; then
   echo "[CoW][INFO][main][start-stop] Using $CONFIG"
else
   echo "[CoW][ERROR][main][start-stop] No $CONFIG found, exiting ..."
   exit 1
fi

if [[ "$ACTION" = "start" ||  "$ACTION" = "stop" ]];  then
  case $CONTAINERS in
      jenkins )
      echo "[CoW][INFO][main][start-stop]  $ACTION Jenkins 2"
  	   ./jenkins/startStop.sh $CONFIG $ACTION
  	;;
      nexus )
      echo "[CoW][INFO][main][start-stop]  $ACTION Nexus 3"
      ./nexus3/startStop.sh $CONFIG $ACTION
  	;;
      sonar )
      echo "[CoW][INFO][main][start-stop]  $ACTION SonarQube 5"
      ./sonarqube5/startStop.sh $CONFIG $ACTION
  	;;
      * )
      echo "[CoW][INFO][main][start-stop]  $ACTION all [Jenkins 2, SonarQube 5, Nexus 3]"
      echo "[CoW][INFO][main][start-stop]  $ACTION Jenkins 2"
      ./jenkins/startStop.sh $CONFIG $ACTION
      echo "[CoW][INFO][main][start-stop]  $ACTION SonarQube 5"
      ./sonarqube5/startStop.sh $CONFIG $ACTION
      echo "[CoW][INFO][main][start-stop]  $ACTION Nexus 3"
      ./nexus3/startStop.sh $CONFIG $ACTION
  	exit ;;
  esac
else
  echo "[CoW][ERROR][main][start-stop] $ACTION is not valid. Valid actions are [start, stop]"
  exit 1
fi;
