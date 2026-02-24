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
| DuckDNS | Dynamic DNS |
| Prometheus | Metrics collection |
| Grafana | Metrics visualization |
| Node Exporter | Hardware/OS metrics |
| UFW | Firewall |
| Fail2ban | Brute-force protection |

---

## 🔒 Security Setup

- SSH hardened: password authentication disabled, key-only access
- Root login disabled
- UFW firewall: default deny incoming, only SSH and WireGuard allowed
- Admin services only accessible via VPN/SSH tunnel
- No services exposed directly to the internet

---

## 🌐 Network Architecture

- All admin services are VPN-only — nothing exposed publicly except WireGuard
- Dynamic DNS via DuckDNS keeps the domain updated as home IP changes
- WireGuard chosen for its simplicity, speed, and modern cryptography

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
| [docs/networking.md](docs/networking.md) | DuckDNS dynamic DNS |
| [docs/vpn.md](docs/vpn.md) | WireGuard VPN setup |
| [docs/monitoring.md](docs/monitoring.md) | Prometheus + Grafana stack |

---

## 🎯 Goals

Building this homelab to develop practical, hands-on experience in:
- Linux system administration
- Network security and service isolation
- Docker and containerization
- Monitoring and observability
- Infrastructure documentation

---

## 🚀 Planned Next Phases

### Phase 2 — Game Server Hosting
- Self-hosted game servers (Minecraft, and others)
- Container-based deployment and management

### Phase 3 — Security Lab
- Dedicated environment for learning ethical hacking and cybersecurity
- CTF practice and vulnerability research
- Isolated network for safe experimentation

---

## 📚 Learning Journey

This project started with zero homelab experience. Every decision,
mistake, and fix is documented. The goal is not just to have a working
server but to understand why everything works the way it does.

---

*Built and maintained by Marshixel*
