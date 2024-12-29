#! /bin/bash

#
# $1: restic repository path
#

docker compose stop
restic --repo $1 backup --tag mealie ./data
docker compose start