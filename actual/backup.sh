#! /bin/bash

#
# $1: restic repository path
#

docker compose stop
restic --repo $1 backup --tag actual ./data
docker compose start