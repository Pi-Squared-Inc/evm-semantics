#!/bin/bash

set -euo pipefail

export LD_LIBRARY_PATH=/app/evm-semantics/libkevm:/app/vlm/kllvm
RPC_ENDPOINT=http://188.40.132.230:8545
[ $# -ne 2 ] && { echo "usage: $0 <block-delta>"; exit 1; }
block_delta_min=$1
block_delta_max=$2
shift 2

for i in $(seq "$block_delta_min" "$block_delta_max")
do
  num=$(/app/bin/geth-generate "$RPC_ENDPOINT" . "$i")
  if [ $? -ne 0 ]; then
    echo "Failed to generate block delta $i"
    continue
  fi
  /app/bin/geth-stock-kevm-validate . "$num"
  if [ $? -ne 0 ]; then
    mkdir -p fail
    mv block_* fail
  else
    mkdir -p pass
    mv block_* pass
  fi
done

