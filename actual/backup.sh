#! /bin/bash

docker compose stop
tar -czf $2/actual_$1.tar.gz ./data
docker compose start