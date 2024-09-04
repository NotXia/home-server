#! /bin/bash

mkdir .vaultwarden_bckp
sqlite3 vw-data/db.sqlite3 ".backup '.vaultwarden_bckp/db.sqlite3'"
tar -czf $2/vaultwarden_$1.tar.gz .vaultwarden_bckp
rm -rf .vaultwarden_bckp