#!/usr/bin/env bash

set -e

cd $_CONTAINER_USER_HOME

su $_CONTAINER_USER << EOF
curl -fsSL https://bun.sh/install | bash
EOF
