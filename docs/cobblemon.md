# Minecraft — Cobblemon Server (COBBLEVERSE Modpack)

## What is this?
A self-hosted Minecraft 1.21.1 Fabric modded server running the COBBLEVERSE - Pokemon Adventure [Cobblemon] modpack.
Cobblemon is a Minecraft mod that adds Pokémon to the game in a faithful, Minecraft-style way.
The modpack includes additional mods for exploration, storage, economy, and Pokémon battling.

## Access
- Server address (local): `192.168.2.170:25566`
- Server address (external): `marshixelhomelab.duckdns.org:25566`
- Port: 25566 (external) → 25565 (internal)

## Stack
- itzg/minecraft-server:java21
- Minecraft 1.21.1 with Fabric Loader 0.18.4
- Modpack: COBBLEVERSE - Pokemon Adventure [Cobblemon] v1.7.2
- CurseForge API for mod downloads (with local zip fallback)

## Security
- Whitelist enabled (Marshixel only by default)
- No direct web exposure, port 25566 forwarded in Fritz!Box

## Mods note
The modpack zip was manually downloaded from CurseForge and placed in the data folder
because the modpack author disabled automatic distribution.
Additionally, `cobblemon_party_extras` was manually added to `/data/mods/` because
it was missing from the modpack but required by `cobblemon_randomizer`.

## Config
See [docker/minecraft-cobblemon/docker-compose.yml](../docker/minecraft-cobblemon/docker-compose.yml)

Sensitive values (CF_API_KEY) are stored in /srv/gameservers/minecraft-cobblemon/.env
and never committed to GitHub.

To rebuild:
1. Copy the compose file to `/srv/gameservers/minecraft-cobblemon/`
2. Create a `.env` file with `CF_API_KEY=your_key` (get from https://console.curseforge.com)
3. Download the modpack zip from CurseForge and place in `/srv/gameservers/minecraft-cobblemon/data/`
4. Download `cobblemon_party_extras` from Modrinth and place in `/srv/gameservers/minecraft-cobblemon/data/mods/`
5. Run `docker compose up -d`

## Problems encountered

### Problem 1: CurseForge API key rejected
The API key contained `$` signs which Docker Compose interprets as variable substitution.
Using `$$` to escape each `$` in the compose file caused the key to be passed incorrectly.
Fixed by moving the API key to a `.env` file where no escaping is needed,
and referencing it as `${CF_API_KEY}` in the compose file.

### Problem 2: Modpack not allowed for automatic distribution
CurseForge returned an error saying the modpack authors disabled project distribution.
Fixed by manually downloading the modpack zip from CurseForge and passing it via
`CF_MODPACK_ZIP` environment variable, while keeping `CF_PAGE_URL` for identification.

### Problem 3: Wrong Java version
The default `itzg/minecraft-server:latest` image uses Java 25 but Cobblemon 1.7.1 requires Java 21.
Synapse crashed on startup with an incompatible mods error.
Fixed by changing the image to `itzg/minecraft-server:java21`.

### Problem 4: Missing cobblemon_party_extras mod
The modpack included `cobblemon_randomizer` which depends on `cobblemon_party_extras`,
but that mod was not included in the modpack.
Fixed by manually downloading `cobblemon_party_extras` from Modrinth and placing it in `/data/mods/`.
The jar must be placed in the `mods` subfolder, not the root `data` folder.

### Problem 5: Wrong port mapping
The compose file had `25566:25566` but Minecraft listens on 25565 inside the container.
Docker was binding the external port but nothing was listening on 25566 internally,
causing connection refused errors even though the port appeared open.
Fixed by changing the mapping to `25566:25565`.

### Problem 6: NAT loopback preventing local connection
Connecting via `marshixelhomelab.duckdns.org:25566` from inside the local network failed
because the Telekomrouter blocks hairpin NAT (connecting to your own public IP from inside).
Fixed by using the local IP `192.168.2.170:25566` when connecting from the same network.
External players connect via `marshixelhomelab.duckdns.org:25566` as normal.

## Lessons learned
- Docker Compose escapes `$` as `$$` — always use `.env` files for keys containing `$`
- `itzg/minecraft-server` image tag controls Java version — use `:java21` not `:latest` for older modpacks
- Port mapping must match what the application listens on inside the container, not the external port
- Always check `docker compose down && docker compose up -d` after changing port mappings — restart alone is not enough
- Telekomrouter NAT loopback doesn't work — use local IP for same-network connections
