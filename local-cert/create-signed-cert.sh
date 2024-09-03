#! /bin/bash

#
# Create a signed certificate for the domain (and subdomains) given in $1.
#

mkdir -p ./https

openssl genrsa -out ./https/local-https.key 2048
openssl req -new -key ./https/local-https.key -out ./https/local-https.csr

echo "authorityKeyIdentifier=keyid,issuer" > ./https/local-https.ext
echo "basicConstraints=CA:FALSE" >> ./https/local-https.ext
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> ./https/local-https.ext
echo "subjectAltName = @alt_names" >> ./https/local-https.ext
echo "[alt_names]" >> ./https/local-https.ext
echo "DNS.1 = $1" >> ./https/local-https.ext
echo "DNS.2 = *.$1" >> ./https/local-https.ext

openssl x509 -req \
    -in ./https/local-https.csr \
    -CA ./ca/local-ca.pem \
    -CAkey ./ca/local-ca.key \
    -CAcreateserial \
    -days 365 \
    -sha256 \
    -extfile ./https/local-https.ext \
    -out ./https/local-https.crt