#!/usr/bin/env bash

set -e

DENO_VERSION="${VERSION:-"1.38.1"}"

if [ "$(uname -m)" = "aarch64" ]; then
  wget -c -O deno.zip "https://github.com/LukeChannings/deno-arm64/releases/download/v${DENO_VERSION}/deno-linux-arm64.zip";
else
  wget -c -O deno.zip "https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip";
fi

unzip -o deno.zip
rm -f deno.zip

mv deno /usr/local/bin
