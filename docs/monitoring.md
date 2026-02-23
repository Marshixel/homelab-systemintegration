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
