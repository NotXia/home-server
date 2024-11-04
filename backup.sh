#! /bin/bash

#
# $1: backups root directory
# $2: number of recent backups to keep
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TIMESTAMP=$(date +%Y%m%d%H%M%S)
KEEP_AMOUNT=$2
BACKUP_ROOT=$1
BACKUP_DIR=$BACKUP_ROOT/$(date +%Y-%m-%d_%H.%M.%S)


cd $SCRIPT_DIR
mkdir -p $BACKUP_DIR


runBackupSh () {
    cd $1
    ./backup.sh $TIMESTAMP $BACKUP_DIR
    cd ..
}


echo "Backing up .env"
cp .env $BACKUP_DIR/.env.bckp

echo "Backing up CA certificates"
runBackupSh local-cert

echo "Backing up Pi-hole"
runBackupSh pihole

echo "Backing up Vaultwarden"
runBackupSh vaultwarden

echo "Backing up WireGuard"
runBackupSh wireguard

echo "Backing up Mealie"
runBackupSh mealie

echo "Backing up Actual"
runBackupSh actual

echo "Backing up Paperless"
runBackupSh paperless


echo "Removing old backups"
cd $BACKUP_ROOT
SKIP_LINES=$(($KEEP_AMOUNT+2))
ls -lt | tail -n +$SKIP_LINES | awk '{print $9}' | xargs rm -r