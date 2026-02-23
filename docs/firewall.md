## FIREWALL CONFIG

## Why deny incoming by default 
Blocks everything unless you explicitly allow it, minimizing attack surface

## Why allow outgoing
Your server needs to reach the internet for updates, Docker pulls etc.

## Why allow port 22
That's SSH, if you forget this you lock yourself out

## Why port 51820 UDP 
That's WireGuard VPN which you'll set up later

## Why UFW 
It's a simple frontend for iptables, easier to manage
