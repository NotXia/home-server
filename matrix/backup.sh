#! /bin/bash

#
# $1: restic repository path
#

source .env

docker exec -it matrix-db pg_dump -Fc --exclude-table-data e2e_one_time_keys_json --username=synapse synapse > ./synapse-db.dump

restic --repo $1 backup --tag matrix \
    ./synapse_data/homeserver.yaml \
    ./synapse_data/${SYNAPSE_SUBDOMAIN}.${PUBLIC_DOMAIN}.log.config \
    ./synapse_data/${SYNAPSE_SUBDOMAIN}.${PUBLIC_DOMAIN}.signing.key \
    ./synapse_data/media_store/local_content \
    ./synapse_data/media_store/remote_content \
    ./synapse-db.dump

rm ./synapse-db.dump