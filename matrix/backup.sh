#! /bin/bash

source .env
mkdir -p ./.backup

cp synapse_data/homeserver.yaml ./.backup/.
cp synapse_data/matrix.notxia.duckdns.org.log.config ./.backup/.
cp synapse_data/matrix.notxia.duckdns.org.signing.key ./.backup/.

if [ -d ./synapse_data/media_store/local_content ]; then
    tar -czf .backup/local_content.tar.gz ./synapse_data/media_store/local_content
fi
if [ -d ./synapse_data/media_store/remote_content ]; then
    tar -czf .backup/remote_content.tar.gz ./synapse_data/media_store/remote_content
fi

docker exec -it matrix-db pg_dump -Fc --exclude-table-data e2e_one_time_keys_json --username=synapse synapse > .backup/synapse.dump

tar -czf $2/matrix_$1.tar.gz ./.backup
rm -rf ./.backup