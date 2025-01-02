#! /bin/bash

#
# $1: restic local repository path
# $2: restic remote repository path
# $3: number of recent snapshots to keep
# $4: remote path for media backups
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
RESTIC_LOCAL_REPO=$1
RESTIC_REMOTE_REPO=$2
KEEP_AMOUNT=$3
MEDIA_BACKUP_PATH=$4

cd $SCRIPT_DIR
export RESTIC_PASSWORD_FILE=$SCRIPT_DIR/.restic
restic init --repo $RESTIC_LOCAL_REPO &> /dev/null
restic init --repo $RESTIC_REMOTE_REPO &> /dev/null


runBackupSh () {
    cd $1
    ./backup.setup.sh
    echo $'\n'"-- Snapshotting to ${RESTIC_LOCAL_REPO}"
    ./backup.create.sh $RESTIC_LOCAL_REPO
    echo $'\n'"-- Snapshotting to ${RESTIC_REMOTE_REPO}"
    ./backup.create.sh $RESTIC_REMOTE_REPO
    if [ -f ./backup.media.sh ]; then
        echo $'\n'"-- Backing up media to ${MEDIA_BACKUP_PATH}"
        ./backup.media.sh $MEDIA_BACKUP_PATH
    fi
    ./backup.cleanup.sh
    cd ..
}


echo ">>> Backing up .env"
restic --repo $RESTIC_LOCAL_REPO backup --tag env .env
restic --repo $RESTIC_REMOTE_REPO backup --tag env .env

echo $'\n\n\n'">>> Backing up CA certificates"
runBackupSh local-cert

echo $'\n\n\n'">>> Backing up Pi-hole"
runBackupSh pihole

echo $'\n\n\n'">>> Backing up Vaultwarden"
runBackupSh vaultwarden

echo $'\n\n\n'">>> Backing up WireGuard"
runBackupSh wireguard

echo $'\n\n\n'">>> Backing up Mealie"
runBackupSh mealie

echo $'\n\n\n'">>> Backing up Actual"
runBackupSh actual

echo $'\n\n\n'">>> Backing up Paperless"
runBackupSh paperless

echo $'\n\n\n'">>> Backing up Matrix"
runBackupSh matrix

echo $'\n\n\n'">>> Backing up Immich"
runBackupSh immich


echo $'\n\n\n'">>> Removing old snapshots in ${RESTIC_LOCAL_REPO}"
restic --repo $RESTIC_LOCAL_REPO forget --prune --group-by tags --keep-last $KEEP_AMOUNT
echo $'\n\n\n'">>> Removing old snapshots in ${RESTIC_REMOTE_REPO}"
restic --repo $RESTIC_REMOTE_REPO forget --prune --group-by tags --keep-last $KEEP_AMOUNT