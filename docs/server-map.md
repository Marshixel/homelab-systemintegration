# 🗺️ Server Map — Quick Reference

A cheat sheet for navigating and managing the homelab server.

---

## 📁 Directory Structure
```
/srv/
  /gameservers/
    /minecraft-vanilla/     — Minecraft Java (Paper)
  /monitoring/              — Prometheus, Grafana, Node Exporter
  /nginx/                   — Nginx Proxy Manager
  /vaultwarden/             — Vaultwarden password manager
  /wireguard/               — WireGuard VPN
  /backups/                 — Local server backups

/etc/
  /wireguard/               — WireGuard client configs (local machine)

~/duckdns/                  — DuckDNS update script
~/homelab-systemintegration/ — Git repository and documentation
```

---

## 🐳 Docker — Common Commands

### Navigate to a service
```bash
cd /srv/monitoring
cd /srv/nginx
cd /srv/vaultwarden
cd /srv/wireguard
cd /srv/gameservers/minecraft-vanilla
```

### Start a service
```bash
cd /srv/<service>
docker compose up -d
```

### Stop a service
```bash
cd /srv/<service>
docker compose down
```

### Restart a service
```bash
cd /srv/<service>
docker compose restart
```

### View running containers
```bash
docker ps
```

### View logs
```bash
docker logs -f <container-name>
```

### Send a command to Minecraft
```bash
docker exec minecraft-vanilla rcon-cli "<command>"
# Examples:
docker exec minecraft-vanilla rcon-cli "whitelist add Username"
docker exec minecraft-vanilla rcon-cli "whitelist remove Username"
docker exec minecraft-vanilla rcon-cli "op Username"
docker exec minecraft-vanilla rcon-cli "whitelist list"
```

---

## ✏️ Editing a Docker Compose File
```bash
sudo nano /srv/<service>/docker-compose.yml
```

After editing, apply the changes:
```bash
cd /srv/<service>
docker compose down
docker compose up -d
```

---

## 🔄 Updating a Docker Image
```bash
cd /srv/<service>
docker compose pull
docker compose up -d
```

---

## 🌐 Services & Access

| Service | URL | Notes |
|---------|-----|-------|
| Vaultwarden | https://vaultwarden-marshixel.duckdns.org | Password manager |
| Grafana | https://grafana-marshixel.duckdns.org | Monitoring |
| Nginx Proxy Manager | http://192.168.2.170:81 | Local network only |
| Minecraft | marshixelhomelab.duckdns.org:25565 | Friends connect here |

---

## 📝 GitHub — Documentation Workflow

### Navigate to repo
```bash
cd ~/homelab-systemintegration
```

### Create a new doc
```bash
nano docs/new-doc.md
```

### Push changes to GitHub
```bash
cd ~/homelab-systemintegration
git add .
git commit -m "Description of what you changed"
git push
```

### Update an existing Docker config in repo
```bash
cp /srv/<service>/docker-compose.yml docker/<service>/docker-compose.yml
git add .
git commit -m "Update <service> docker config"
git push
```

---

## 🔧 System — Common Commands

### Check disk space
```bash
df -h
```

### Check RAM usage
```bash
free -h
```

### Check what's running
```bash
docker ps
sudo systemctl status wings  # if applicable
```

### Check firewall rules
```bash
sudo ufw status
```

### Manual backup
```bash
sudo /usr/local/bin/backup.sh
```

### Manual remote sync to PC
```bash
sudo /usr/local/bin/backup-remote.sh
```

### View backup log
```bash
cat /var/log/backup-remote.log
```

---

## 🔑 SSH & VPN

### SSH into server (local network)
```bash
ssh marshixel@192.168.2.170
```

### SSH into server (via VPN)
```bash
ssh marshixel@10.13.13.1
```

### WireGuard VPN status
```bash
docker exec wireguard wg show
```

### Generate new WireGuard peer QR code
```bash
docker exec wireguard /app/show-peer 1
```

---

## 📦 Adding a New Service

1. Create the folder:
```bash
sudo mkdir -p /srv/<service-name>
```

2. Create the compose file:
```bash
sudo nano /srv/<service-name>/docker-compose.yml
```

3. Start it:
```bash
cd /srv/<service-name>
docker compose up -d
```

4. Add to repo:
```bash
mkdir -p ~/homelab-systemintegration/docker/<service-name>
cp /srv/<service-name>/docker-compose.yml ~/homelab-systemintegration/docker/<service-name>/
```

5. Create documentation:
```bash
nano ~/homelab-systemintegration/docs/<service-name>.md
```

6. Push to GitHub:
```bash
cd ~/homelab-systemintegration
git add .
git commit -m "Add <service-name> service"
git push
```
