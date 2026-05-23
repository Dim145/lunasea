# syntax=docker/dockerfile:1.6

ARG NODE_VERSION=22

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
# `node:22-alpine` ships with a pre-created `node` user (UID/GID 1000).
# We chown the app dir and drop to that user — no root at runtime.
FROM node:${NODE_VERSION}-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/JagandeepBrar/LunaSea-Notification-Service"
LABEL org.opencontainers.image.title="lunasea-notification-service"

# tini reaps zombies and forwards signals; install while still root.
# At the same time, strip `npm` / `npx` / `corepack`: the runtime never
# invokes them, but their bundled deps (picomatch, ip-address,
# brace-expansion) keep triggering Trivy CVE alerts. Removing them
# eliminates the attack surface entirely.
RUN apk add --no-cache tini wget \
    && rm -rf /usr/local/lib/node_modules/npm \
              /usr/local/lib/node_modules/corepack \
              /usr/local/bin/npm \
              /usr/local/bin/npx \
              /usr/local/bin/corepack

WORKDIR /usr/src/app

# Lay down sources owned by the `node` user so the runtime can read them
# without ever needing root.
COPY --from=build --chown=node:node /usr/src/app/node_modules ./node_modules
COPY --from=build --chown=node:node /usr/src/app/dist ./dist
COPY --from=build --chown=node:node /usr/src/app/package.json ./package.json

USER node

ENV NODE_ENV=production
EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- --spider http://127.0.0.1:9000/health || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "-r", "dotenv/config", "dist/index.js"]
