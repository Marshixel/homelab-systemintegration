# Vaultwarden — Self-hosted Password Manager

## What is Vaultwarden?
Vaultwarden is a lightweight, self-hosted implementation of Bitwarden.
It stores all passwords on your own server instead of a third-party cloud.
Compatible with all official Bitwarden clients (browser extension, mobile app).

## Why self-hosted?
- Full control over your password data
- No dependency on third-party services
- Free, no subscription needed

## Access
https://marshixelhomelab.duckdns.org

## Security
- HTTPS enforced via Nginx Proxy Manager and Let's Encrypt
- Signups disabled after initial account creation
- No direct port exposure, all traffic goes through NPM reverse proxy

## Stack
- vaultwarden/server:latest
- Nginx Proxy Manager for reverse proxy and SSL
- Let's Encrypt certificate via HTTP challenge

## Problems encountered

### Problem 1: 502 Bad Gateway
Vaultwarden and NPM were on different Docker networks and couldn't reach
each other. Fixed by adding Vaultwarden to NPM's network (nginx_default)
using an external network definition in docker-compose.yml.

### Problem 2: Let's Encrypt connection timeout
DuckDNS was not pointing to the correct public IP.
Fixed by updating the IP on the DuckDNS dashboard.

## Client setup
Use the official Bitwarden app or browser extension.
When logging in, set the server URL to:
https://marshixelhomelab.duckdns.org

## Why self-hosted?
- Full control over your password data
- No dependency on third-party services
- Free, no subscription needed
- Ability to update Vaultwarden yourself on your own schedule
- Compatible with GrapheneOS on Google Pixel 10 XL via the official Bitwarden app
  (no Google Play Services required, available via F-Droid or direct APK)

## Push Notifications
Push notifications are enabled so Vaultwarden syncs instantly to mobile clients.

Setup:
- Register at https://bitwarden.com/host to get an Installation ID and Key
- Store credentials in /srv/vaultwarden/.env (never commit this to GitHub)
- Using EU relay servers (api.bitwarden.eu / identity.bitwarden.eu)

Note: .env file is excluded from git to keep credentials private.

## Config
See [docker/vaultwarden/docker-compose.yml](../docker/vaultwarden/docker-compose.yml)

Note: Sensitive values (PUSH_INSTALLATION_ID, PUSH_INSTALLATION_KEY) are
stored in /srv/vaultwarden/.env and never committed to GitHub.
To rebuild: copy the compose file, create a .env file with your credentials
and run docker compose up -d.
