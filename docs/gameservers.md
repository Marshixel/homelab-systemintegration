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

## Planned servers
- Modded Minecraft (Cobblemon)
- Modded Minecraft (ATM10)
- Garry's Mod TTT
- Hytale (when released)

## Friend access
Friends connect via: marshixelhomelab.duckdns.org
Port 25565 forwarded in Fritz!Box router.
