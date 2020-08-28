#!/usr/bin/env bash

### Set environment vars ###
CONTAINER_NAME="docker-proxy"

# Build the new version
docker build -t "$CONTAINER_NAME" .

# Run container in the background
docker run -d --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"

# Foreground run for debugging
# docker run --rm --name "$CONTAINER_NAME" -p 8080:80 "$CONTAINER_NAME"
