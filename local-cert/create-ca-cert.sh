#! /bin/bash

#
# Create a key and certificate for a local CA.
#

mkdir -p ./ca

# Create private key if needed
if [ ! -f ./ca/local-ca.key ]; then
    openssl genrsa -out ./ca/local-ca.key 2048
fi

openssl req -x509 -new -nodes -key ./ca/local-ca.key -sha256 -days 365 -out ./ca/local-ca.pem
