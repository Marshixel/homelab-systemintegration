# Nginx Proxy Manager — Reverse Proxy & SSL

## What is Nginx Proxy Manager?
NPM is a reverse proxy with a web UI that handles routing and SSL certificates.
All services are accessible via HTTPS through NPM instead of being exposed directly.

## Why NPM?
- Automatic SSL certificates via Let's Encrypt
- Web UI instead of editing config files
- Single entry point for all services
- Hides internal ports from the internet

## Access
Admin panel: http://192.168.2.170:81 (local network only)

## Proxy Hosts
| Domain | Service | Port |
|--------|---------|------|
| vaultwarden-marshixel.duckdns.org | Vaultwarden | 80 |
| grafana-marshixel.duckdns.org | Grafana | 3000 |

## SSL
All certificates are Let's Encrypt via HTTP challenge.
Auto-renews before expiry.

## Docker network
NPM uses nginx_default network.
All services that need to be proxied must join this network.

## Problems encountered

### Problem 1: 502 Bad Gateway
Services on different Docker networks couldn't reach NPM.
Fixed by adding services to the nginx_default external network
in their docker-compose.yml files.

### Problem 2: Grafana YAML error
Duplicate network definitions in docker-compose.yml caused a YAML parse error.
Fixed by properly structuring the networks section with a single
top-level networks block.

## Config
See [docker/nginx/docker-compose.yml](../docker/nginx/docker-compose.yml)

To rebuild: copy the compose file to /srv/nginx and run docker compose up -d.
Then recreate proxy hosts and SSL certificates via the web UI at port 81.
