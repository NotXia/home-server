#! /bin/bash

source .env

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

bash ../traefik/dumpacme.sh ../traefik/letsencrypt/acme.json ${PUBLIC_DOMAIN} ./coturn-tls
docker restart coturn