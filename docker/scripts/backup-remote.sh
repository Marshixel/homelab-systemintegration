#!/bin/bash

PC_IP="192.168.2.62"
PC_USER="marshixel"
PC_DIR="/home/marshixel/server-backups"
BACKUP_DIR="/srv/backups"
SSH_KEY="/root/.ssh/backup_key"
LOG="/var/log/backup-remote.log"

echo "[$(date)] Starting remote backup sync" >> $LOG

# Check if PC is online
if ! ping -c 1 -W 2 $PC_IP > /dev/null 2>&1; then
    echo "[$(date)] PC is offline, skipping remote backup" >> $LOG
    exit 0
fi

# Sync backups to PC
rsync -avz --delete \
    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
    $BACKUP_DIR/ \
    $PC_USER@$PC_IP:$PC_DIR/

if [ $? -eq 0 ]; then
    echo "[$(date)] Remote backup sync completed successfully" >> $LOG
else
    echo "[$(date)] Remote backup sync failed" >> $LOG
fi
