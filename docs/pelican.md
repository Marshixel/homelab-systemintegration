# Pelican Panel — Game Server Manager (Abandoned)

## What is Pelican?
Pelican is a modern fork of Pterodactyl, a web-based game server management panel.
It allows you to deploy, manage and monitor game servers via a web UI.
Wings is the daemon component that runs on the same machine and actually executes the servers.

## Why I tried it
I wanted a panel to manage multiple game servers (Minecraft, Cobblemon, ATM10, TTT)
and be able to turn them on and off without running everything at once.

## Installation
- PHP 8.3, Composer, nginx installed directly on the host
- Pelican panel deployed at /var/www/pelican
- Wings binary installed at /usr/local/bin/wings
- Panel accessible via https://pelican-marshixel.duckdns.org (since removed)
- Wings accessible via https://wings-marshixel.duckdns.org (since removed)

## Problems encountered

### Problem 1: Panel CSS/JS not loading
After initial setup the panel loaded without any styling.
Root cause: APP_URL was set to http:// instead of https://, causing mixed content blocks.
Fix: Updated APP_URL in .env to https://pelican-marshixel.duckdns.org and cleared cache.

### Problem 2: 500 Server Error
Panel threw 500 errors intermittently.
Root cause: File permission issues on /var/www/pelican/storage/framework/cache.
Fix: sudo chown -R www-data:www-data /var/www/pelican/storage

### Problem 3: Node connection red
Wings was running but the panel showed the node as unreachable.
Root cause: Port 8443 not forwarded in Fritz!Box router.
Fix: Added port forwarding rule for 8443 TCP in Fritz!Box.

### Problem 4: WebSocket connection failed
Panel could reach Wings but the server console would not load.
Error: "websocket: the client is not using the websocket protocol:
'upgrade' token not found in 'Connection' header"
Attempted fixes:
- Added WebSocket headers to NPM custom nginx config
- Enabled WebSockets Support toggle in NPM
- Switched Wings from reverse proxy mode to direct SSL mode
- Copied Let's Encrypt certificates from NPM to Wings
- Added allowed_origins to Wings config
- Added NAT loopback fix in /etc/hosts
- Tried HTTP/2 on and off
- Recreated NPM proxy host from scratch
None of these fully resolved the WebSocket issue.

### Problem 5: Panel config being overwritten
Wings kept resetting ssl: enabled back to false on restart.
Root cause: ignore_panel_config_updates was set to false by default.
Fix: Set ignore_panel_config_updates: true in /etc/pelican/config.yml

### Problem 6: Minecraft server crash on start
The Minecraft server installed successfully but crashed immediately on start.
Root cause: Wrong Java version — Paper 1.19 requires a newer Java than what
the Docker image provided by default.
This was never resolved as the WebSocket issue prevented console access.

## Why I gave up
Pelican is currently in beta (v1.0.0-beta24) and has several rough edges:
- WebSocket proxying through NPM is unreliable and poorly documented
- Configuration gets silently overwritten by the panel
- Error messages are vague and hard to debug
- Documentation for self-hosted reverse proxy setups is incomplete

## Decision
Removed Pelican and Wings completely from the system.
All related DuckDNS subdomains, NPM proxy hosts and SSL certificates were deleted.

## Cleanup performed
- Wings service stopped, disabled and removed
- /etc/pelican, /var/lib/pelican, /var/log/pelican removed
- /var/www/pelican removed
- nginx and PHP 8.3 removed from system
- UFW rules for ports 8080, 8443, 2022 removed
- Docker networks pelican_nw and pelican0 removed
- DuckDNS update script cleaned up

## Future plans
Will evaluate alternative game server managers:
- Crafty Controller (Minecraft focused)
- AMP (multi-game support)
- Plain Docker containers per game server
