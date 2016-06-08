#!/bin/bash
CONFIG=$1
CONTAINERS=$2

if [ -e $CONFIG ]; then
    echo "[CoW][INFO][main][run] Loading $CONFIG"
else
   echo "[CoW][ERROR][main][run] No $CONFIG found, exiting ..."
   exit 1
fi

case $CONTAINERS in
    jenkins )
    echo "[CoW][INFO][main][run] Build Jenkins 2"
	   ./jenkins/run.sh $CONFIG jenkins/
	;;
    nexus )
    echo "[CoW][INFO][main][run] Build Nexus 3"
    ./nexus3/run.sh $CONFIG nexus3/
	;;
    sonar )
    echo "[CoW][INFO][main][run] Build SonarQube 5"
    ./sonarqube5/run.sh $CONFIG sonarqube5/
	;;
    * )
    echo "[CoW][INFO][main][run] Build all [Jenkins 2, SonarQube 5, Nexus 3]"
    echo "[CoW][INFO][main][run] Build Jenkins 2"
    ./jenkins/run.sh $CONFIG jenkins/
    echo "[CoW][INFO][main][run] Build SonarQube 5"
    ./sonarqube5/run.sh $CONFIG sonarqube5/
    echo "[CoW][INFO][main][run] Build Nexus 3"
    ./nexus3/run.sh $CONFIG nexus3/
	exit ;;
esac
