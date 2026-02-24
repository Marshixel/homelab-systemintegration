# Monitoring Stack

## Components
- **Prometheus** — collects and stores metrics from the server
- **Grafana** — visualizes the metrics in dashboards (runs on port 3000)
- **node-exporter** — exposes hardware and OS metrics for Prometheus to scrape

## Why this stack?
Industry standard monitoring setup used in professional environments.
Gives full visibility into server health: CPU, RAM, disk, network.

## How it works
node-exporter collects system metrics → Prometheus scrapes them every 15s → Grafana displays them.

## Access
- Grafana dashboard: http://192.168.2.170:3000
- Prometheus: http://192.168.2.170:9090

## Files
- /srv/monitoring/docker-compose.yml
- /srv/monitoring/prometheus.yml


# Monitoring Stack - Redo

## Components
- **Prometheus** — collects and stores metrics from the server
- **Grafana** — visualizes metrics in dashboards (dashboard ID 1860 - Node Exporter Full)
- **node-exporter** — exposes hardware and OS metrics for Prometheus to scrape

## Why this stack?
Industry standard monitoring setup used in professional environments.
Gives full visibility into server health: CPU, RAM, disk, network.

## Architecture
node-exporter collects system metrics → Prometheus scrapes every 15s → Grafana displays them.

## Access
Grafana is accessible via SSH tunnel:
```bash
ssh -L 3000:localhost:3000 marshixel@192.168.2.170
```
Then open http://localhost:3000

## Problems encountered and solutions

### Problem 1: Grafana not accessible via VPN
Tried binding Grafana to the WireGuard IP (10.13.13.1) but Docker could not 
assign that address. Tried UFW rules to restrict access but Docker bypasses 
UFW by default. Solution: use SSH tunnel to access Grafana securely.

### Problem 2: Prometheus could not scrape node-exporter
node-exporter runs with network_mode: host so it exists outside Docker's 
internal network. Prometheus could not reach it via container name. 
Tried localhost:9100 and node-exporter:9100, both failed.
Solution: use the Docker bridge gateway IP (172.20.0.1:9100) and allow 
that subnet through UFW with:
```bash
sudo ufw allow from 172.20.0.0/16 to any port 9100
```

### Problem 3: Wrong gateway IP
Initially used 172.17.0.1 (default Docker bridge) but Prometheus was on 
a custom network with gateway 172.20.0.1. Found correct IP with:
```bash
docker inspect prometheus | grep Gateway
```

## Lessons learned
- Docker networking is complex when mixing network_mode: host with bridge networks
- Docker bypasses UFW rules by default, requiring direct IP-based firewall rules
- Always inspect container networking when containers can't reach each other
- AI assisted debugging by reading logs and identifying root causes step by step

## Config
See [docker/monitoring/docker-compose.yml](../docker/monitoring/docker-compose.yml)
See [docker/monitoring/prometheus.yml](../docker/monitoring/prometheus.yml)

To rebuild: copy both files to /srv/monitoring and run docker compose up -d.
Remember to allow Docker subnets through UFW for node-exporter access.
