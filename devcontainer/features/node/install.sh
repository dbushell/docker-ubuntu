#!/usr/bin/env bash

set -e

NODE_VERSION="${VERSION:-"current"}"

curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash

apt update \
  && apt upgrade -y \
  && apt install -y nodejs

cd $_CONTAINER_USER_HOME

su $_CONTAINER_USER << EOF
mkdir -p "$_CONTAINER_USER_HOME/.npm"
echo "prefix=~/.npm/packages" > "$_CONTAINER_USER_HOME/.npmrc"
npm install -g npm npm-check-updates
EOF
