#!/usr/bin/env bash

set -e

OS="${OS:-"linux"}"
ARCH="${ARCH:-"amd64"}"
MODULES="${MODULES:-""}"

URL="https://caddyserver.com/api/download"
URL="${URL}?os=${OS}&arch=${ARCH}"

for MOD in $(echo $MODULES | sed "s/,/ /g"); do
  if [[ $MOD =~ ^[a-z]+: ]]; then
    MOD="${MOD#*//}"
  fi
  if [[ $MOD =~ \.[a-z]+/ ]]; then
    URL="${URL}&p=${MOD}"
  else
    URL="${URL}&p=github.com/${MOD}"
  fi
done

URL="${URL}&idempotency=$(date +%s%N)"

wget -O /usr/local/bin/caddy "${URL}"

chmod +x /usr/local/bin/caddy
