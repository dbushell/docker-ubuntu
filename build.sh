#!/bin/bash
docker buildx build --no-cache \
  -f ./Dockerfile --platform linux/arm64,linux/amd64 \
  -t ghcr.io/dbushell/ubuntu \
  --push .
