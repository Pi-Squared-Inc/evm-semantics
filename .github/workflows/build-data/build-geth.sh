#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
GETH_REPO=github.com/ethereum/go-ethereum
GETH_BRANCH=v1.15.10
VSL_APP_REPO=github.com/Pi-Squared-Inc/vsl-blockchain-app.git
VSL_APP_BRANCH=cse-profiling

if [ ! -d /app ]; then
  echo "Unexpected directory layout"
  exit 1
fi

# change to work directory
cd /app

# clone and patch repos
[ ! -d /app/vsl  ] && git clone --depth=1 --branch ${VSL_APP_BRANCH} https://${VSL_APP_REPO} vsl
if [ ! -d /app/geth ]; then
  git clone --depth=1 --branch ${GETH_BRANCH} https://${GETH_REPO} geth
  cp $SCRIPT_DIR/kevm.go /app/geth/core/vm
  (cd /app/geth; git apply --verbose "$SCRIPT_DIR/op-geth-kevm.patch")
fi

# build evm-semantics
make -C /app/evm-semantics evm-semantics

# build binary directory
mkdir -p /app/bin

# build binaries
cd /app/vsl/standalone-stateless
./build.sh /app/bin geth-generator geth-generate geth-generate
./build.sh /app/bin geth-log-validator geth-log-validate geth-log-validate
./build.sh /app/bin geth-validator geth-validate geth-kevm-validate /app/vlm/op-geth geth-kevm-validator
./build.sh /app/bin geth-validator geth-validate geth-stock-kevm-validate /app/geth geth-stock-kevm-validator
