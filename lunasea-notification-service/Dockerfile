# syntax=docker/dockerfile:1.6

ARG NODE_VERSION=24

# ---- Build stage ----
FROM node:${NODE_VERSION}-alpine AS build
WORKDIR /usr/src/app

# Cache-friendly: install deps before copying sources
COPY package.json package-lock.json ./
RUN npm ci

# Compile TypeScript
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

# Trim down to production deps for the runtime layer
RUN npm prune --omit=dev

# ---- Runtime stage ----
# `gcr.io/distroless/nodejs24-debian12:nonroot` ships Node 24, a `nonroot`
# user (UID 65532), and nothing else — no shell, no apk/apt, no npm, no
# wget. The image's ENTRYPOINT is already `["/nodejs/bin/node"]`, so CMD
# below is just the script's argv.
FROM gcr.io/distroless/nodejs24-debian12:nonroot AS runtime
LABEL org.opencontainers.image.source="https://github.com/JagandeepBrar/LunaSea-Notification-Service"
LABEL org.opencontainers.image.title="lunasea-notification-service"

WORKDIR /app

# Use numeric UID:GID — distroless has /etc/passwd entries, but pinning
# to 65532 avoids any reliance on name resolution.
COPY --from=build --chown=65532:65532 /usr/src/app/node_modules ./node_modules
COPY --from=build --chown=65532:65532 /usr/src/app/dist ./dist
COPY --from=build --chown=65532:65532 /usr/src/app/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 9000

# No wget in distroless; probe via Node's built-in http module instead.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/nodejs/bin/node", "-e", "require('http').get('http://127.0.0.1:9000/health', r => process.exit(r.statusCode === 200 ? 0 : 1)).on('error', () => process.exit(1))"]

CMD ["-r", "dotenv/config", "dist/index.js"]
