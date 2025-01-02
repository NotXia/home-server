#! /bin/bash

docker exec -it matrix-db pg_dump -Fc --exclude-table-data e2e_one_time_keys_json --username=synapse synapse > ./synapse-db.dump