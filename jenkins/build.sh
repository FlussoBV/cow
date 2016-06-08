#!/bin/bash
#1=context, #2 jenkins image, #3 slave image, #4 proxy image
SOURCE_IMAGE=jenkins:2.0
echo "[CoW][INFO][Jenkins2][build] Pulling Jenkins source image ($SOURCE_IMAGE)"
docker pull $SOURCE_IMAGE   >> cow.log 2>&1

CONTEXT_LOCATION_DEFAULT=.
CONTEXT_LOCATION="${1:-$CONTEXT_LOCATION_DEFAULT}"

TAGNAME_DEFAULT="jenkins-image"
TAGNAME="${2:-$TAGNAME_DEFAULT}"

echo "[CoW][INFO][Jenkins2][build] Building new Jenkins with tag=$TAGNAME"
docker build --tag=$TAGNAME ${CONTEXT_LOCATION}   >> cow.log 2>&1

./${CONTEXT_LOCATION}slave/build.sh ${CONTEXT_LOCATION}slave/ $3
./${CONTEXT_LOCATION}proxy/build.sh ${CONTEXT_LOCATION}proxy/ $4
