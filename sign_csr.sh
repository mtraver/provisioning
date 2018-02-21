#!/bin/bash
set -euo pipefail

usage() {
  echo "usage: $(basename $0) csr_file"
}

if [ "$#" -ne 1 ]; then
  usage
  exit 2
fi

readonly csr_file="$1"

openssl ca -config openssl.cnf -in "$csr_file" -out "${csr_file%.csr}.x509"
