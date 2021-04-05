#!/bin/bash

docker buildx build \
  -f ./Dockerfile --platform linux/arm64/v8,linux/x86_64 \
  -t dbushell/ubuntu \
  -t ghcr.io/dbushell/ubuntu \
  --push .
