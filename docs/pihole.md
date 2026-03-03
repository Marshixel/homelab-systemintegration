# Pi-hole

## What is this?
Pi-hole is a network-wide DNS adblocker. It acts as a DNS server for your local network,
blocking ads, trackers, and malicious domains at the DNS level before they even reach your devices.
All devices on the network benefit without needing any browser extensions or client-side software.

## Access
- Web interface (local only): `http://192.168.2.170:8080/admin`
- No external access — Pi-hole only needs to be reachable on the local network

## Stack
- pihole/pihole:latest
- DNS port: 53 (TCP + UDP)
- Web interface port: 8080 (mapped from internal 80)

## Config
See [docker/pihole/docker-compose.yml](../docker/pihole/docker-compose.yml)

Key settings:
- `TZ: Europe/Berlin`
- `FTLCONF_dns_listeningMode: ALL` — required for Docker bridge networking
- `FTLCONF_dns_upstreams: 1.1.1.1;8.8.8.8` — upstream DNS (Cloudflare + Google)
- Password stored in compose file as `FTLCONF_webserver_api_password`

## Setup notes

### Problem 1: Port 53 already in use
`systemd-resolved` listens on port 53 by default, conflicting with Pi-hole.
Fixed by disabling the DNS stub listener in `/etc/systemd/resolved.conf`:
```
[Resolve]
DNSStubListener=no
```
Then restarted resolved: `sudo systemctl restart systemd-resolved`

### Problem 2: Port 80/443 conflict with Nginx Proxy Manager
Pi-hole's default compose uses ports 80 and 443 which NPM already occupies.
Fixed by mapping Pi-hole's web interface to port 8080 instead: `8080:80/tcp`
Port 443 removed entirely since NPM handles SSL termination.

### Problem 3: DNS resolution unavailable on first start
Pi-hole couldn't resolve DNS to download blocklists on fresh start.
Fixed by explicitly setting upstream DNS servers via `FTLCONF_dns_upstreams`.

## Using Pi-hole on your network
To actually block ads on your devices, set your DNS server to `192.168.2.170` on each device,
or set it in your Fritz!Box under Home Network → Network → DNS so all devices use it automatically.

## Notes
- No DuckDNS subdomain assigned — DuckDNS free tier is limited to 5 subdomains, all used
- Pi-hole does not need external access to function
- Blocklists update automatically via cron inside the container
