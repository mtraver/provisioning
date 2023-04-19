#!/bin/bash
set -euo pipefail

usage() {
  echo "usage: $(basename $0)"
}

readonly out_dir="ca"

# Set up the files and directories need by the CA
mkdir -p "$out_dir"
mkdir -p "${out_dir}/certs"
mkdir -p "${out_dir}/private"
touch "${out_dir}/index.txt"
echo '01' > "${out_dir}/ca.srl"

readonly key_file="${out_dir}/private/ca.pem"
readonly cert_file="${out_dir}/ca.x509"

# Make the CA's key
openssl genrsa -aes256 -out "${key_file}" 4096

# Make the CA's self-signed cert
openssl req -config openssl.cnf -new -x509 -sha256 -days 365000 \
  -extensions v3_ca -key "$key_file" -out "$cert_file"

chmod 400 "$key_file" "$cert_file"
