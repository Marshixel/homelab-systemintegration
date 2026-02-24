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

# Firewall — UFW Setup

## Philosophy
Default deny all incoming traffic. Only explicitly allow what is needed.
This minimizes the attack surface of the server.

## Rules

| Port | Protocol | Action | Source | Reason |
|------|----------|--------|--------|--------|
| 22 | TCP | ALLOW | Anywhere | SSH access |
| 51820 | UDP | ALLOW | Anywhere | WireGuard VPN |
| 9100 | TCP | ALLOW | 172.17.0.0/16 | Prometheus → node-exporter (Docker bridge) |
| 9100 | TCP | ALLOW | 172.19.0.0/16 | Prometheus → node-exporter (monitoring network) |
| 9100 | TCP | ALLOW | 172.20.0.0/16 | Prometheus → node-exporter (updated gateway) |
| 3000 | TCP | DENY | Anywhere | Block public Grafana access |
| 3000 | TCP | ALLOW | 10.13.13.0/24 | Allow Grafana via WireGuard subnet only |

## Problems encountered

### Problem 1: Docker bypasses UFW
Docker manages its own iptables rules and bypasses UFW by default.
This means UFW DENY rules don't always work for Docker-exposed ports.
Grafana port 3000 was blocked via UFW but Docker still exposed it.
Solution: bind Grafana to 127.0.0.1 in docker-compose.yml instead of relying on UFW.

### Problem 2: Multiple Docker networks
Prometheus kept getting different gateway IPs depending on which Docker network
it was assigned to. Had to allow multiple subnets (172.17, 172.19, 172.20)
because Docker creates new networks with different gateways each time.
Found correct gateway with:
```bash
docker inspect prometheus | grep Gateway
```

## Lessons learned
- UFW and Docker don't work well together out of the box
- Always bind sensitive services to 127.0.0.1 in Docker rather than relying on firewall rules
- Docker networking requires understanding bridge networks and gateway IPs
