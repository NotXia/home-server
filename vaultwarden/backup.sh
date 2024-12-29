#! /bin/bash

#
# $1: restic repository path
#

sqlite3 vw-data/db.sqlite3 ".backup 'db.sqlite3'"
restic --repo $1 backup --tag vaultwarden db.sqlite3
rm db.sqlite3