# Networking — DuckDNS Dynamic DNS

## What is DuckDNS?
DuckDNS is a free dynamic DNS service that gives your homelab a fixed domain name.
Home internet connections usually have a dynamic IP (it changes randomly).
DuckDNS solves this by mapping a domain to your current IP automatically.

## My domain
marshixelhomelab.duckdns.org

## How it works
A script runs every 5 minutes via cron job and tells DuckDNS what our current IP is.
DuckDNS then updates the domain to point to that IP.

## Files
- ~/duckdns/update.sh — script that sends IP to DuckDNS
- ~/duckdns/duck.log — log file to verify updates are working

## Cron job
*/5 * * * * ~/duckdns/update.sh >/dev/null 2>&1
Runs every 5 minutes automatically.

# Networking — Dynamic DNS & Subdomains

## What is DuckDNS?
DuckDNS is a free dynamic DNS service that gives your homelab fixed domain names.
Home internet connections usually have a dynamic IP (it changes randomly).
DuckDNS solves this by mapping domains to your current IP automatically.

## Domains
| Domain | Service |
|--------|---------|
| marshixelhomelab.duckdns.org | Main domain |
| vaultwarden-marshixel.duckdns.org | Vaultwarden password manager |
| grafana-marshixel.duckdns.org | Grafana monitoring dashboard |

## How it works
A script runs every 5 minutes via cron job and updates all domains at once.

## Files
- ~/duckdns/update.sh — script that sends IP to DuckDNS
- ~/duckdns/duck.log — log file to verify updates are working

## Cron job
```bash
*/5 * * * * ~/duckdns/update.sh >/dev/null 2>&1
```

## Future plans
When a custom domain is purchased, migrate to Cloudflare for:
- Better DDoS protection
- DNS challenge for SSL certificates
- Professional domain name for CV
