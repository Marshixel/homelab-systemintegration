# Backup Strategy

## Overview
Monthly automated backup of the entire server including all Docker services,
home directory and system configuration files.

## What is backed up
- /srv — all Docker services and their data (Vaultwarden, Grafana, NPM, WireGuard)
- /home/marshixel — home directory
- /etc — system configuration files

## Storage
- Location: /srv/backups
- Maximum 5 backups kept, older ones are automatically deleted
- Format: tar.gz compressed archive

## Schedule
Runs automatically on the 1st of every month at 23:00 via cron job:
```bash
0 23 1 * * /usr/local/bin/backup.sh
```

## What happens during backup
1. All Docker containers are stopped for a clean backup
2. tar.gz archive is created with timestamp
3. Docker containers are restarted
4. Old backups beyond the limit of 5 are deleted

## Limitations
- Local backup only — if the SSD fails, backups are lost too
- Planned improvement: add remote or external backup destination

## Script location
/usr/local/bin/backup.sh

## Manual backup
To run a backup manually:
```bash
sudo /usr/local/bin/backup.sh
```
