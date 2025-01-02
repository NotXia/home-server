#! /bin/bash

#
# $1: restic repository path
#

source .env

restic --repo $1 backup --tag matrix \
    ./synapse_data/homeserver.yaml \
    ./synapse_data/${SYNAPSE_SUBDOMAIN}.${PUBLIC_DOMAIN}.log.config \
    ./synapse_data/${SYNAPSE_SUBDOMAIN}.${PUBLIC_DOMAIN}.signing.key \
    ./synapse_data/media_store/local_content \
    ./synapse_data/media_store/remote_content \
    ./synapse-db.dump