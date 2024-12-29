#! /bin/bash

#
# $1: restic repository path
# $2: number of recent snapshots to keep
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
RESTIC_REPO=$1
KEEP_AMOUNT=$2

export RESTIC_PASSWORD_FILE=$SCRIPT_DIR/.restic
restic init --repo $RESTIC_REPO &> /dev/null


runBackupSh () {
    cd $1
    ./backup.sh $RESTIC_REPO
    cd ..
}


echo "Backing up .env"
restic --repo $RESTIC_REPO backup --tag env .env

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

echo "Backing up Matrix"
runBackupSh matrix


echo "Removing old snapshots"
restic --repo $RESTIC_REPO forget --prune --group-by tags --keep-last $KEEP_AMOUNT