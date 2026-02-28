# Hytale Server

## What is this?
A self-hosted Hytale dedicated server running in Docker. Hytale is a game by Hypixel Studios
built on a custom engine. The server runs in authenticated mode, meaning players need a
real Hytale account to connect.

## Access
- Server address (local): `192.168.2.170:5520`
- Server address (external): `marshixelhomelab.duckdns.org:5520`
- Protocol: UDP port 5520

## Stack
- ghcr.io/godstepx/docker-hytale-server:latest
- Hytale version: 2026.02.19-1a311a592 (auto-updates on container start)
- Authentication: Authenticated mode (Hytale account required)

## Setup
The server was set up using https://setuphytale.com — a compose file generator that handles
all the configuration. On first run the container requires two OAuth authorizations:

1. One to download the server files from Hytale's CDN
2. One to authenticate the server session with Hypixel's session service

Both are done by visiting a URL printed in the logs and entering a short code.
After that, tokens are cached and the server starts automatically on subsequent restarts.

## Config
See [docker/hytale/docker-compose.yml](../docker/hytale/docker-compose.yml)

Key settings:
- `AUTH_MODE: authenticated` — players need a Hytale account to join
- `MAX_PLAYERS: 100`
- `MAX_VIEW_RADIUS: 32`
- `HYTALE_PATCHLINE: release` — always downloads the latest release build
- Memory: 8G min / 8G max

## Network
- Port 5520 UDP forwarded in Telekomrouter
- Port 5520 UDP allowed in UFW (`sudo ufw allow 5520/udp`)
- Friends connect via `marshixelhomelab.duckdns.org:5520`
- Local connections use `192.168.2.170:5520` (Telekomrouter NAT loopback doesn't work)

## Re-authentication
The server session token expires periodically. The container handles background token refresh
automatically every 24 hours. If tokens ever become invalid after a long downtime, run:

```bash
cd /srv/gameservers/hytale
docker compose down
docker compose run --rm hytale
```

This will prompt for OAuth authorization again via the URL/code flow.

## Notes
- The server auto-downloads the latest Hytale release on every fresh start
- All players must have a valid Hytale account — the server validates sessions against
  Hypixel's session service at sessions.hytale.com
- Hytale is still in early access/beta so expect updates and potential breaking changes
