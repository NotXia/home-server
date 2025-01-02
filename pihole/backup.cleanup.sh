#! /bin/bash

rm ./pihole.tag.gz
docker exec pihole rm /backup/pihole.tag.gz