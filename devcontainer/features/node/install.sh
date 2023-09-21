#!/usr/bin/env bash

set -e

NODE_VERSION="${VERSION:-"20.x"}"

# https://github.com/nodesource/distributions#installation-instructions
apt update
apt install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt update
apt install -y nodejs

cd $_CONTAINER_USER_HOME

su $_CONTAINER_USER << EOF
mkdir -p "$_CONTAINER_USER_HOME/.npm"
echo "prefix=~/.npm/packages" > "$_CONTAINER_USER_HOME/.npmrc"
npm install -g npm npm-check-updates
EOF
