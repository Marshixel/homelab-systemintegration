# Backup Strategy

## Overview
Monthly automated backup of the entire server including all Docker services,
home directory and system configuration files. Backups are synced to a remote
PC for redundancy.

## What is backed up
- /srv — all Docker services and their data
- /home/marshixel — home directory
- /etc — system configuration files

## Storage
- Local: /srv/backups (maximum 2 backups kept)
- Remote: /home/marshixel/server-backups on CachyOS PC (192.168.2.71)
- Format: tar.gz compressed archive

## Schedule
- Full backup: 1st of every month at 23:00
- Remote sync retry: every day at 09:00 (in case PC was offline on backup night)
```bash
0 23 1 * * /usr/local/bin/backup.sh
0 9 * * * /usr/local/bin/backup-remote.sh
```

## What happens during backup
1. All Docker containers are stopped for a clean backup
2. tar.gz archive is created with timestamp
3. Docker containers are restarted
4. Old local backups beyond limit of 2 are deleted
5. Backup is synced to PC via rsync over SSH

## If PC is offline
The remote sync script checks if the PC is online before syncing.
If offline it skips gracefully and logs the attempt.
The daily retry cron job will sync the next morning the PC is online.

## Script locations
- /usr/local/bin/backup.sh — main backup script
- /usr/local/bin/backup-remote.sh — remote sync script

## Manual backup
```bash
sudo /usr/local/bin/backup.sh
```

## Manual remote sync
```bash
sudo /usr/local/bin/backup-remote.sh
```

## Logs
```bash
cat /var/log/backup-remote.log
```

## PC requirements
- SSH server must be running: `sudo systemctl start sshd`
- UFW must allow SSH: `sudo ufw allow ssh`
- Note: sshd is not set to start on boot by default on CachyOS

## Config fix
Ip adress of the PC needs to be static. Change in the Telekomrouter and check "Always the same IPv4 address" on.
