#! /bin/bash

docker exec pihole mkdir -p /backup
docker exec pihole pihole -a -t /backup/pihole_$1.tag.gz
docker cp -q pihole:/backup/pihole_$1.tag.gz $2/.
docker exec pihole rm /backup/pihole_$1.tag.gz