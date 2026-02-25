#!/bin/bash

BACKUP_DIR="/srv/backups"
DATE=$(date +%Y-%m-%d)
MAX_BACKUPS=2

mkdir -p $BACKUP_DIR

echo "Starting backup: $DATE"

# Stop containers to ensure clean backup
docker stop $(docker ps -q)

# Create backup
tar --exclude=/srv/backups \
    -czf "$BACKUP_DIR/server-backup-$DATE.tar.gz" \
    /srv \
    /home/marshixel \
    /etc

# Restart containers
docker start $(docker ps -aq)

echo "Backup created: server-backup-$DATE.tar.gz"

# Delete old backups, keep only 5 most recent
ls -t $BACKUP_DIR/server-backup-*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm
# Sync to PC
/usr/local/bin/backup-remote.sh
echo "Done. Current backups:"
ls -lh $BACKUP_DIR
