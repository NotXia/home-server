#! /bin/bash

docker exec -t immich-db pg_dumpall --clean --if-exists --username=postgres > "./immich-db.dump"
