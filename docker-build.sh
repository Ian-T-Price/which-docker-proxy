#!/usr/bin/env bash

### Aid memoire ###
# apachectl -t -D DUMP_INCLUDES
# apachectl -t -D DUMP_MODULES
# ps alias:
# for i in $(cd /proc && echo +([0-9])); do echo -n "$i " ; if [ -f /proc/$i/cmdline ] ; \
#  then cat /proc/$i/cmdline ; fi ; echo ; done

### Set environment vars ###
CONTAINER_NAME="docker-proxy"

### Args ###
REFRESH=9
set -u
while [[ $# -gt 0 ]]; do
  case $1 in
    -r) shift; REFRESH=$1 ;;
    -h | '--help' | *) echo -e "\n There's only one optional ARG accepted: -r nn where nn is a integer\n"; exit 1 ;;
  esac
  shift
done
set +u

### Container vars ###
UNSET_HTTP_HEADER='Accept-Encoding:' ##, User-Agent, Cookie'
SET_HTTP_HEADER='User-Agent: "TechTest"' ## Host: "​www.which.co.uk"'


# Remove any existing container, forcefully
docker rm -f "$CONTAINER_NAME"

# Build the new version
docker build -t "$CONTAINER_NAME" --build-arg REFRESH_TIME="$REFRESH" \
  --build-arg UNSET_HEADER="$UNSET_HTTP_HEADER" --build-arg SET_HEADER="$SET_HTTP_HEADER" .

# Run container in the background
docker run -d --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"

# Foreground run for debugging
# docker run --rm --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"

# Wait two secs for it to start & then check
# read -t 1; clear; curl --proxy 192.168.43.111:8080 -L http://www.which.co.uk
read -r -t 1; clear; curl --proxy localhost:8080 -L http://www.which.co.uk
read -r -t 1

# Display the logs
docker logs -f "$CONTAINER_NAME"