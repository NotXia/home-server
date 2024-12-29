#! /bin/bash

#
# $1: restic repository path
#

docker exec pihole mkdir -p /backup
docker exec pihole pihole -a -t /backup/pihole.tag.gz
docker cp -q pihole:/backup/pihole.tag.gz ./pihole.tag.gz

restic --repo $1 backup --tag pihole ./pihole.tag.gz

rm ./pihole.tag.gz
docker exec pihole rm /backup/pihole.tag.gz