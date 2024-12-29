#! /bin/bash

#
# $1: restic repository path
#

mkdir ./export/backup
docker exec -t paperless document_exporter /usr/src/paperless/export/backup

restic --repo $1 backup --tag paperless ./export/backup

rm -rf ./export/backup