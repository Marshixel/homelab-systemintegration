# Matrix — Self-hosted Chat Server

## What is Matrix?
Matrix is an open, federated communication protocol.
Synapse is the reference homeserver implementation — it stores messages on your own server and can communicate with any other Matrix server in the world.
Element is the official web client for Matrix.

## Why self-hosted?
- Full control over your messages and data
- No dependency on third-party services
- Can join any public Matrix room via federation
- Free, no subscription needed

## Access
- Element web client: https://element-marshixel.duckdns.org
- Homeserver API: https://matrix-marshixel.duckdns.org

## Security
- HTTPS enforced via Nginx Proxy Manager and Let's Encrypt
- Federation routed through NPM on port 443 (no direct TLS on 8448)
- Signups open but rate-limited (0.5 per second, burst 5)
- No direct port exposure for client API, all traffic goes through NPM reverse proxy

## Stack
- matrixdotorg/synapse:latest (v1.148.0)
- postgres:16-alpine (database backend)
- vectorim/element-web:latest (web client)
- Nginx Proxy Manager for reverse proxy and SSL
- Let's Encrypt certificate via HTTP challenge

## Federation
This server is fully federated with the wider Matrix network.
Other homeservers connect via port 443 using a .well-known delegation.
The federation tester at https://federationtester.matrix.org confirms FederationOK: true.

To test federation manually:
```bash
curl -s https://matrix-marshixel.duckdns.org/_matrix/federation/v1/version | jq .
```

## Architecture
```
Internet → Fritz!Box (port 443) → NPM (TLS termination)
    → matrix_synapse:8008 (client API + federation)
    → matrix_element:80 (Element web client)
```

All three containers share the nginx_default Docker network so NPM can reach them by container name.

## Problems encountered

### Problem 1: SSL certificate failure for new subdomains
Let's Encrypt HTTP challenge timed out for matrix-marshixel and element-marshixel subdomains.
DNS challenge via DuckDNS also failed because DuckDNS does not support TXT records on
subdomains of subdomains (_acme-challenge.matrix-marshixel.duckdns.org is too deep).
Fixed by adding the subdomains to DuckDNS first, waiting for DNS propagation,
then retrying the HTTP challenge in NPM once the domain resolved correctly.

### Problem 2: Federation not working — connection refused on port 8448
The federation tester returned "connection refused" on port 8448.
Port 8448 was forwarded in Fritz!Box but Synapse had no ports mapping in docker-compose.yml
so Docker was not actually binding the port.
Fixed by adding `ports: - "8448:8448"` to the synapse service in docker-compose.yml.

### Problem 3: Federation timing out after port was opened
After opening port 8448, the federation tester returned a TLS timeout instead of connection refused.
The federation tester expects HTTPS on 8448 but Synapse was serving plain HTTP.
Fixed by routing federation through NPM on port 443 using a .well-known delegation
and adding a custom nginx location block in NPM's Advanced tab for the matrix proxy host:
```nginx
location /.well-known/matrix/server {
    default_type application/json;
    return 200 '{"m.server":"matrix-marshixel.duckdns.org:443"}';
}

location /_matrix/federation {
    proxy_pass http://matrix_synapse:8008;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```
This tells other homeservers to connect on 443 instead of 8448, letting NPM handle TLS.

### Problem 4: Synapse crashing on startup after adding federation listener
Added a second listener block to homeserver.yaml for port 8448 but Synapse crashed with a YAML parse error.
The `-` of the new listener block was not indented correctly — it was flush with the left margin
instead of being indented 2 spaces under `listeners:`.
Fixed by correcting the indentation.

### Problem 5: federation_domain_whitelist blocking all federation
homeserver.yaml had `federation_domain_whitelist: []` which blocks all federation instead of allowing it.
An empty list means "allow nobody", not "allow everyone".
Fixed by removing the line entirely (default behaviour is to allow all federation).

### Problem 6: Element web client stuck on "Verifying…"
Element desktop client showed a spinner after login and never completed verification.
Caused by stale cross-signing state in the Element config directory.
Fixed by clearing the Element config:

### Problem 7: Element mobile app on GrapheneOS could not find the server
Element showed ".well-known not available" when trying to connect.
The /.well-known/matrix/client endpoint was missing from the NPM config.
Mobile apps also require the Access-Control-Allow-Origin header or they reject the response.
Fixed by adding the client well-known location block to NPM's Advanced tab:
```bash
# AppImage / DEB installation
rm -rf ~/.config/Element
# Flatpak installation
rm -rf ~/.var/app/im.riot.Riot/config/Element
```

## Lessons learned
- DuckDNS does not support TXT records on sub-subdomains, making DNS challenge impossible for subdomains
- federation_domain_whitelist: [] blocks all federation — remove the line entirely to allow all
- YAML indentation errors crash Synapse on startup — always check logs with `docker logs matrix_synapse`
- Routing federation through NPM on 443 via .well-known is cleaner than exposing port 8448 directly
- Docker ports mapping is required to expose a port — expose: only makes it reachable inside the Docker network

## Creating an admin user
```bash
docker exec -it matrix_synapse register_new_matrix_user \
    -u @admin -p YOURPASSWORD -a https://matrix-marshixel.duckdns.org
```

## Config
See [docker/matrix/docker-compose.yml](../docker/matrix/docker-compose.yml)

Sensitive values (POSTGRES_PASSWORD) are stored in /srv/matrix/.env and never committed to GitHub.

To rebuild: copy the compose file, create a .env file with POSTGRES_PASSWORD,
generate the Synapse config with:
```bash
docker run --rm \
  -v ./data/synapse:/data \
  -e SYNAPSE_SERVER_NAME=matrix-marshixel.duckdns.org \
  -e SYNAPSE_REPORT_STATS=no \
  matrixdotorg/synapse:latest generate
```
Then run docker compose up -d and create your admin user.
