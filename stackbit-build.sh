#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5deb6dcd358efa001ab1b5cf/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5deb6dcd358efa001ab1b5cf 
fi
curl -s -X POST https://api.stackbit.com/project/5deb6dcd358efa001ab1b5cf/webhook/build/ssgbuild > /dev/null
gatsby build
./inject-netlify-identity-widget.js public
curl -s -X POST https://api.stackbit.com/project/5deb6dcd358efa001ab1b5cf/webhook/build/publish > /dev/null
