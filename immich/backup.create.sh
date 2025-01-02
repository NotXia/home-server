#! /bin/bash

restic --repo $1 backup --tag immich ./immich-db.dump