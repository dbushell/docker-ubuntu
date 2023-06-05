#!/bin/bash

docker buildx build --no-cache \
  -f ./devcontainer/Dockerfile --platform linux/arm64,linux/amd64 \
  -t ghcr.io/dbushell/docker-ubuntu/base \
  --push .
