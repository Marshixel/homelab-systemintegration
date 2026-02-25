# 🏠 Homelab — System Integration
> A self-hosted Linux server environment built for learning, experimentation,
> and practical skill development in system administration, network security,
> and infrastructure management.

---

## 💻 Hardware
| Component | Spec |
|-----------|------|
| Device | HP EliteBook 840 G3 |
| CPU | Intel i5-6300U (4) @ 3.000GHz |
| RAM | 16GB (15874MiB) |
| Storage | 230GB SSD |
| GPU | Intel Skylake GT2 [HD Graphics 520] |
| OS | Ubuntu Server 24.04.4 LTS x86_64 |
| Kernel | 6.8.0-101-generic |

---

## 🛠️ Tech Stack
| Tool | Purpose |
|------|---------|
| Docker | Container management |
| WireGuard | VPN for secure remote access |
| DuckDNS | Dynamic DNS with subdomains |
| Nginx Proxy Manager | Reverse proxy and SSL termination |
| Prometheus | Metrics collection |
| Grafana | Metrics visualization |
| Node Exporter | Hardware/OS metrics |
| Vaultwarden | Self-hosted password manager (Bitwarden compatible) |
| UFW | Firewall |

---

## 🔒 Security Setup
- SSH hardened: password authentication disabled, key-only access
- Root login disabled
- UFW firewall: default deny incoming, allowlist only
- Admin services only accessible via VPN or HTTPS with SSL
- WireGuard VPN for secure remote access from mobile (GrapheneOS)
- Vaultwarden for self-hosted password management with push notifications

---

## 🌐 Network Architecture
- Dynamic DNS via DuckDNS with subdomains per service
- Nginx Proxy Manager handles reverse proxy and Let's Encrypt SSL
- WireGuard VPN for secure remote access
- Services accessible via HTTPS subdomains:
  - `vaultwarden-marshixel.duckdns.org` — Password manager
  - `grafana-marshixel.duckdns.org` — Monitoring dashboard

---

## 🎮 Game Servers
Game servers run as individual Docker containers, started and stopped as needed.
Only one or two run simultaneously due to hardware constraints.

| Server | Status | Port |
|--------|--------|------|
| Minecraft Java (Paper) | Active | 25565 |
| Modded Minecraft (Cobblemon) | Planned | - |
| Modded Minecraft (ATM10) | Planned | - |
| Garry's Mod TTT | Planned | - |
| Hytale | Planned (not released) | - |

Friends connect via: `marshixelhomelab.duckdns.org`

---

## 💾 Backup Strategy
- Monthly automated full server backup via cron
- Local backups kept on server (max 2)
- Remote backups synced to personal PC via rsync over SSH
- Daily retry in case PC was offline during backup

---

## 📁 Documentation
Every step of this project is documented including problems encountered
and how they were solved. This is intentional — real infrastructure work
involves debugging, and documenting that process is part of learning.

| File | Description |
|------|-------------|
| [docs/base-system.md](docs/base-system.md) | Base system setup |
| [docs/security.md](docs/security.md) | SSH hardening and firewall |
| [docs/docker-installation.md](docs/docker-installation.md) | Docker setup |
| [docs/networking.md](docs/networking.md) | DuckDNS and subdomains |
| [docs/vpn.md](docs/vpn.md) | WireGuard VPN setup |
| [docs/firewall.md](docs/firewall.md) | UFW firewall rules |
| [docs/monitoring.md](docs/monitoring.md) | Prometheus + Grafana stack |
| [docs/nginx-proxy-manager.md](docs/nginx-proxy-manager.md) | Reverse proxy and SSL |
| [docs/vaultwarden.md](docs/vaultwarden.md) | Self-hosted password manager |
| [docs/backup.md](docs/backup.md) | Backup strategy |
| [docs/gameservers.md](docs/gameservers.md) | Game server management |
| [docs/pelican.md](docs/pelican.md) | Pelican setup attempt and lessons learned |

---

## 🎯 Goals
Building this homelab to develop practical, hands-on experience in:
- Linux system administration
- Network security and service isolation
- Docker and containerization
- Monitoring and observability
- Infrastructure documentation
- Real-world troubleshooting and problem solving

---

## 🚀 Planned Next Phases

### Phase 2 — Communication & Services
- TeamSpeak 6 server for voice chat
- Matrix/Element for self-hosted messaging
- IRC server (Ergo)
- XMPP server (Prosody)

### Phase 3 — Security Lab
- Dedicated environment for learning ethical hacking and cybersecurity
- CTF practice and vulnerability research
- Isolated network for safe experimentation

---

## 📚 Learning Journey
This project started with zero homelab experience. Every decision,
mistake, and fix is documented — including failed attempts like the
Pelican game server panel which was abandoned due to beta instability.
The goal is not just to have a working server but to understand why
everything works the way it does.

---

*Built and maintained by Marshixel*
