#! /bin/bash

docker exec pihole mkdir -p /backup
docker exec pihole pihole -a -t /backup/pihole.tag.gz
docker cp -q pihole:/backup/pihole.tag.gz ./pihole.tag.gz
