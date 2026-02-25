# Game Servers

## Overview
Game servers run as individual Docker containers in /srv/gameservers.
Each server has its own folder with a docker-compose.yml file.
Only run one or two servers at a time due to hardware limits.

## Hardware limits
- CPU: Intel i5-6300U (4 cores)
- RAM: 16GB (max ~12GB allocated to game servers)
- Storage: 230GB SSD

## Managing servers
Start a server:
```bash
cd /srv/gameservers/<server-name>
docker compose up -d
```

Stop a server:
```bash
docker compose down
```

View console/logs:
```bash
docker logs -f <container-name>
```

Send a command to the server:
```bash
docker exec <container-name> rcon-cli <command>
```

## Servers

### Minecraft Vanilla (Paper)
- Container: minecraft-vanilla
- Port: 25565
- Version: Latest
- Type: Paper
- Difficulty: Hard
- Whitelist: enabled
- Path: /srv/gameservers/minecraft-vanilla
- Docker config: [docker/gameservers/minecraft-vanilla/docker-compose.yml](../docker/gameservers/minecraft-vanilla/docker-compose.yml)

## Known issues & troubleshooting

### PaperMC download fails on startup
If the server fails to start with "Failed to download paper" errors,
the PaperMC CDN (fill.papermc.io) is temporarily down.
The container will automatically retry — just wait a few minutes.

### Whitelist username not found
Usernames must be valid Java Edition accounts.
If you get "Could not resolve user from Playerdb" the username is wrong or doesn't exist.
Fix: docker exec minecraft-vanilla rcon-cli "whitelist remove WrongName"
     docker exec minecraft-vanilla rcon-cli "whitelist add CorrectName"

## Planned servers
- Modded Minecraft (Cobblemon)
- Modded Minecraft (ATM10)
- Garry's Mod TTT
- Hytale
- Hytale Modded

## Friend access
Friends connect via: marshixelhomelab.duckdns.org
Port 25565 forwarded in Telekom router.
