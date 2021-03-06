#!/bin/bash

set -e

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
INSTALL_DIR=$HOME/ton-sdk

if [ "$#" -ne 0 ]; then
  INSTALL_DIR=$1
fi

mkdir -p "${INSTALL_DIR}/lib"
mkdir -p "${INSTALL_DIR}/include"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  cp "$SRC_DIR/deps/lib/x64/libton_client.so" "${INSTALL_DIR}/lib"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  cp "$SRC_DIR/deps/lib/x64/libton_client.dylib" "${INSTALL_DIR}/lib"
  install_name_tool -id @loader_path/libton_client.dylib ${INSTALL_DIR}/lib/libton_client.dylib
fi

cp "$SRC_DIR/deps/include/tonclient.h" "${INSTALL_DIR}/include"

echo "TON SDK is successfully installed into ${INSTALL_DIR}"

