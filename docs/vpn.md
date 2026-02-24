# VPN — WireGuard (Docker Version)

## Why VPN?
Instead of exposing services directly to the internet, we run a VPN.
This means admin services are only accessible if you're connected to the VPN.
Much safer than opening ports for every service.

## Why Docker?
Running WireGuard in Docker keeps it isolated and easy to manage.
No manual kernel module setup, just a compose file and one command.

## Why linuxserver/wireguard image?
Maintained by LinuxServer.io, well documented and regularly updated.

## Configuration
- SERVERURL: marshixelhomelab.duckdns.org — our DuckDNS domain
- SERVERPORT: 51820 — the port we opened in UFW
- PEERS: 1 — number of devices that can connect (increase for more devices)
- TZ: Europe/Berlin — server timezone

## Architecture decision
Admin services are only accessible via VPN.
Nothing is exposed directly to the internet except the VPN port itself.

## How to start
```bash
cd /srv/wireguard
docker compose up -d
```

## Config
See [docker/wireguard/docker-compose.yml](../docker/wireguard/docker-compose.yml)

To rebuild: copy the compose file to /srv/wireguard and run docker compose up -d.
Note: peer configs in /srv/wireguard/config are not committed to GitHub for security.
Generate new peer configs after rebuilding.
