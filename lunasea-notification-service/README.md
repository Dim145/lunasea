# LunaSea Notification Service (ntfy edition)

A TypeScript backend that receives webhooks from Sonarr / Radarr / Lidarr /
Tautulli / Overseerr / custom sources and forwards them as push notifications
to a self-hosted [ntfy](https://ntfy.sh) server.

This is a fork of the original LunaSea notification service that
**replaces Firebase / FCM with ntfy**, removing the dependency on a
proprietary cloud and on Redis.

## Architecture

```
Sonarr/Radarr/etc.
     │ webhook
     ▼
[ this service ]  ── POST ──▶  ntfy server  ──▶  subscribed devices
```

Each LunaSea (or other ntfy-compatible) client subscribes to a topic.
Webhooks are routed by topic in the URL:

```
POST /v1/sonarr/<topic>        ?profile=foo&sound=true&interruption_level=active
POST /v1/radarr/<topic>
POST /v1/lidarr/<topic>
POST /v1/tautulli/<topic>
POST /v1/overseerr/<topic>
POST /v1/custom/<topic>
```

The topic acts as the destination address — anyone who knows it can publish.
For defense in depth, you can also require a Bearer token on the ingress
(see `WEBHOOK_TOKEN` below).

## Configuration

All variables can be set via the environment or a `.env` file at the project
root. A template is provided in `.env.sample`.

| Variable             | Required | Default | Notes                                                                 |
| -------------------- | :------: | :-----: | --------------------------------------------------------------------- |
| `NTFY_BASE_URL`      |    ✓     |    —    | Base URL of your ntfy server (e.g. `https://ntfy.example.com`)        |
| `FANART_TV_API_KEY`  |    ✓     |    —    | Fanart.tv API key for Lidarr artist images                            |
| `THEMOVIEDB_API_KEY` |    ✓     |    —    | TheMovieDB API key for Sonarr/Radarr posters                          |
| `NTFY_TOKEN`         |    ·     |   —    | Bearer token if your ntfy server requires auth to publish            |
| `WEBHOOK_TOKEN`      |    ·     |   —    | When set, incoming webhooks must include `Authorization: Bearer …`   |
| `PORT`               |    ·     |  9000   | HTTP listen port                                                      |

## Docker

```bash
docker run -d \
    -e NTFY_BASE_URL=https://ntfy.example.com \
    -e FANART_TV_API_KEY=… \
    -e THEMOVIEDB_API_KEY=… \
    -p 9000:9000 \
    --restart unless-stopped \
    lunasea-notification-service:latest
```

### docker-compose with a self-hosted ntfy

```yaml
services:
  ntfy:
    image: binwiederhier/ntfy
    command: serve
    volumes:
      - ./ntfy:/etc/ntfy
      - ./ntfy-cache:/var/cache/ntfy
    ports: ["80:80"]

  notifications:
    image: lunasea-notification-service:latest
    environment:
      NTFY_BASE_URL: http://ntfy
      FANART_TV_API_KEY: ${FANART_TV_API_KEY}
      THEMOVIEDB_API_KEY: ${THEMOVIEDB_API_KEY}
    ports: ["9000:9000"]
    depends_on: [ntfy]
```

## Development

```bash
npm install
cp .env.sample .env  # fill it in
npm start            # starts nodemon on src/index.ts
```

Build:

```bash
npm run build        # tsc → dist/
npm run serve        # runs dist/index.js
```

Lint:

```bash
npm run lint
```

## iOS caveat

ntfy can deliver to the official ntfy Android app out of the box from a
self-hosted server. The iOS push pipeline goes through Apple's APNs and
ntfy.sh's Firebase project; pure self-hosting iOS push notifications
requires either configuring `upstream-base-url` on the ntfy server to relay
through ntfy.sh, or running your own APNs credentials in the iOS build.

## License

GPL-3.0-only (inherited from upstream).
