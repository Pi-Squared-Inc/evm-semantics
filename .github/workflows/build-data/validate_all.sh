#!/bin/bash

set -euo pipefail

[ $# -ne 1 ] && { echo "usage: $0 <dir>"; exit 1; }

dir=$1
cd "$dir"
for f in $(ls block_verifctxt_*)
do
  f=${f%.json}
  f=${f#block_verifctxt_}
  /app/bin/geth-stock-kevm-validate . "$f" 2>/dev/null
  [ $? -ne 0 ] && { echo "Failed to validate $f"; }
done
