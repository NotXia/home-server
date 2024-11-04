#! /bin/bash

mkdir ./export/backup
docker exec -t paperless document_exporter /usr/src/paperless/export/backup
tar -czf $2/paperless_$1.tar.gz ./export/backup
rm -rf ./export/backup