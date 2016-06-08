#!/bin/bash
# #1 context, #2 image name
CONTEXT_LOCATION_DEFAULT=.
CONTEXT_LOCATION="${1:-$CONTEXT_LOCATION_DEFAULT}"

TAGNAME_DEFAULT="jenkins-slave-image"
TAGNAME="${2:-$CONTEXT_LOCATION_DEFAULT}"

echo "[CoW][INFO][Jenkins2-slave][build] Building new Jenkins Slave with tag=$TAGNAME"
docker build --tag=$TAGNAME ${CONTEXT_LOCATION}  >> cow.log 2>&1
