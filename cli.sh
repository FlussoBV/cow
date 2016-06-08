#!/bin/bash
#1=config, #2=action,#3=service
CONFIG=$1
ACTION=$2

LOG=cow.log
SERVICE_DEFAULT="ALL"
SERVICE="${3:-$SERVICE_DEFAULT}"

echo "==========================================="
echo "== CoW - Continuous integration On (a) Whale =="
echo "    \   ^__^ "
echo "     \  (oo)\_______"
echo "        (__)\       )\/\ "
echo "            ||--WWW | "
echo "            ||      | "
echo "[CoW][info]  CoW CLI 1.0"
echo "================================"
WHOAMI=`whoami`
echo "[CoW][INFO][main]  CONFIG  =$CONFIG"
echo "[CoW][INFO][main]  ACTION  =$ACTION"
echo "[CoW][INFO][main]  SERVICE =$SERVICE"

if [ -e $LOG ]; then
   rm $LOG
fi
touch $LOG

. ./config/defaults.conf
echo "[CoW][INFO][main]  Loading ${CONFIG}.conf..."
CONFIG="./config/${CONFIG}.conf"

if [ -e $CONFIG ]; then
   . $CONFIG
else
   echo "[CoW][ERROR] No $CONFIG found, exiting ..."
   exit 1
fi

echo "================================"
case $ACTION in
    build )
	   echo "[CoW][INFO][main] Building images [Start]"
     # time
     ./build-containers.sh $CONFIG $SERVICE
     echo "[CoW][INFO][main] Building images [End]"
	;;
    run )
    # time
    echo "[CoW][INFO][main]  Running containers [Start]"
    ./run-containers.sh $CONFIG $SERVICE
    if [ -e $CONTAINER_START_COMMAND ]; then
       $CONTAINER_START_COMMAND
    fi
    echo "[CoW][INFO][main]  Running containers [End]"
	;;
    start )
    echo "[CoW][info]  Start containers [Start]"
    # time
    ./start-stop-containers.sh $CONFIG $SERVICE start
    if [ -e $CONTAINER_START_COMMAND ]; then
       $CONTAINER_START_COMMAND
    fi
    echo "[CoW][INFO][main]  Start containers [End]"
	;;
    stop )
    echo "[CoW][INFO][main] Stop containers [Start]"
    # time
    ./start-stop-containers.sh $CONFIG $SERVICE stop
    echo "[CoW][INFO][main]  Stop containers [End]"
  ;;
    init )
    echo "[CoW][INFO][main]  Initialize [Start]"
    # time
    ./init.sh $CONFIG $SERVICE
    ls -lath $HOMEDIR  >> cow.log 2>&1
    echo "[CoW][INFO][main]  Initialize [End]"
	;;
    * )
	echo "[CoW][ERROR] [main]action $ACTION not known, possible actions [init, build, run, start, stop]"
	exit ;;
esac
echo "================================"
echo "================================"
echo "== To check if all containers are running in the network"
echo "== docker network inspect ${NETWORK}"
echo "================================"
echo "[CoW][INFO][main]  Done"
echo "================================"
