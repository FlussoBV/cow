#!/bin/bash
# #1 config file
CONFIG=$1
CONTAINERS=$2
. ./config/defaults.conf
if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR][main][build]No $CONFIG found, exiting ..."
   exit 1
fi


case $CONTAINERS in
    jenkins )
      echo "[CoW][INFO][main][build]  Build Jenkins 2"
	   ./jenkins/build.sh jenkins/ $JENKINS_IMAGE $JENKINS_SLAVE_IMAGE $JENKINS_PROXY_IMAGE
	;;
    nexus )
    echo "[CoW][INFO][main][build]  Build Nexus 3"
    ./nexus3/build.sh nexus3/ $NEXUS_IMAGE $NEXUS_PROXY_IMAGE
	;;
    sonar )
    echo "[CoW][INFO][main][build]  Build SonarQube 5"
    ./sonarqube5/build.sh sonarqube5/ $SONARQUBE_IMAGE $SONARQUBE_PROXY_IMAGE
	;;
    * )
    echo "[CoW][INFO][main][build]  Build all [Jenkins 2, SonarQube 5, Nexus 3]"
    echo "[CoW][INFO][main][build]  Build Jenkins 2"
    ./jenkins/build.sh jenkins/ $JENKINS_IMAGE $JENKINS_SLAVE_IMAGE $JENKINS_PROXY_IMAGE
    echo "[CoW][INFO][main][build]  Build SonarQube 5"
    ./sonarqube5/build.sh sonarqube5/ $SONARQUBE_IMAGE $SONARQUBE_PROXY_IMAGE
    echo "[CoW][INFO][main][build]  Build Nexus 3"
    ./nexus3/build.sh nexus3/ $NEXUS_IMAGE $NEXUS_PROXY_IMAGE
	exit ;;
esac
