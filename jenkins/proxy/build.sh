#!/bin/bash
# #1 context, #2 image name
SOURCE_IMAGE=nginx:latest
echo "[CoW][INFO][Jenkins2-proxy][build] Pulling Jenkins proxy source image ($SOURCE_IMAGE)"
docker pull $SOURCE_IMAGE   >> cow.log 2>&1

CONTEXT_LOCATION_DEFAULT=.
CONTEXT_LOCATION="${1:-$CONTEXT_LOCATION_DEFAULT}"

TAGNAME_DEFAULT="jenkins-proxy-image"
TAGNAME="${2:-$TAGNAME_DEFAULT}"

echo "[CoW][INFO][Jenkins2-proxy][build] Building new Jenkins Proxy with tag=$TAGNAME"
docker build --tag=$TAGNAME ${CONTEXT_LOCATION}  >> cow.log 2>&1
