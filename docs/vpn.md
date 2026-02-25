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

## Port forwarding
Port 51820 UDP must be forwarded in the Fritz!Box router to the server.
Without this, external clients cannot reach the WireGuard daemon.

## Client setup (Mobile - GrapheneOS)
1. Install WireGuard from F-Droid
2. Generate QR code on server: `docker exec wireguard /app/show-peer 1`
3. In WireGuard app: tap + → Scan QR code
4. Enable the tunnel

## Testing
With VPN active you can:
- SSH into the server via 10.13.13.1
- Access Vaultwarden internally
- Access Grafana via SSH tunnel

## Troubleshooting
If VPN connects but no data is received:
- Check Telekom port forwarding for 51820 UDP
- Check UFW: sudo ufw status | grep 51820
- Check handshake: docker exec wireguard wg show
