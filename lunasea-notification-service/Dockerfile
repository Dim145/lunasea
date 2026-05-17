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
FROM node:${NODE_VERSION}-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/JagandeepBrar/LunaSea-Notification-Service"
WORKDIR /usr/src/app

RUN apk add --no-cache tini

COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 9000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "-r", "dotenv/config", "dist/index.js"]
