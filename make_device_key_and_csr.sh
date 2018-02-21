#!/bin/bash
set -euo pipefail

usage() {
  echo "usage: $(basename $0) device_id out_dir"
}

if [ "$#" -ne 2 ]; then
  usage
  exit 2
fi

readonly device_id="$1"
readonly out_dir="$2"

# Validate device ID
if [[ ! "$device_id" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Device ID may contain only letters, numbers, dash, and underscore."
  exit 1
fi

mkdir -p "$out_dir"

readonly private_key_file="${out_dir}/${device_id}.pem"
readonly csr_file="${out_dir}/${device_id}.csr"

# Make the device's key.
# https://cloud.google.com/iot/docs/concepts/device-security says
# that the prime256v1 (aka secp256r1 aka NIST P-256) curve should be used.
openssl ecparam -name prime256v1 -genkey -noout -out "$private_key_file"

# Make the CSR, using a custom config that sets the device ID
# as the default common name.
openssl req -config <(cat <<EOF
[ req ]
distinguished_name = req_distinguished_name
string_mask = utf8only

[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
countryName_default         = US
countryName_min             = 2
countryName_max             = 2

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = California

localityName                = Locality Name (e.g. city)

0.organizationName          = Organization Name (e.g. company)

organizationalUnitName      = Organizational Unit Name (e.g. section)

commonName                  = IoT Core Device ID (DO NOT CHANGE! Use the default!)
commonName_default          = "$device_id"
commonName_max              = 64

emailAddress                = Email Address
emailAddress_max            = 64
EOF
) -new -sha256 -key "$private_key_file" -out "$csr_file"
