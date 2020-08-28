#!/usr/bin/env bash

### Aid memoire ###
# apachectl -t -D DUMP_INCLUDES
# apachectl -t -D DUMP_MODULES
# ps alias:
# for i in $(cd /proc && echo +([0-9])); do echo -n "$i " ; if [ -f /proc/$i/cmdline ] ; \
#  then cat /proc/$i/cmdline ; fi ; echo ; done

### Set environment vars ###
CONTAINER_NAME="docker-proxy"

# Remove any existing container, forcefully
docker rm -f "$CONTAINER_NAME"

# Build the new version
docker build -t "$CONTAINER_NAME" .

# Run container in the background
docker run -d --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"

# Foreground run for debugging
# docker run --rm --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"

# Display the logs
docker logs -f "$CONTAINER_NAME"