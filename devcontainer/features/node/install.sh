#!/usr/bin/env bash

set -e

NODE_VERSION="${VERSION:-"current"}"

curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash

apt update \
  && apt upgrade -y \
  && apt install -y nodejs

mkdir -p "$_CONTAINER_USER_HOME/.npm"

cat > "$_CONTAINER_USER_HOME/.npmrc" \
<< EOF
prefix=~/.npm/packages
EOF

npm install -g npm npm-check-updates
