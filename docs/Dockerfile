# syntax=docker/dockerfile:1.6

# ---- Build stage: Jekyll → static HTML ----
FROM --platform=$BUILDPLATFORM ruby:3.3-alpine AS build

# Build-arg controls where the site is mounted on the final server.
# Defaults to `/` so the Docker image is a drop-in static site.
# GitHub Pages overrides this from its own workflow.
ARG BASE_URL=""

WORKDIR /src

# Build deps for native gems (nokogiri, sass-embedded, jekyll-sass-converter).
RUN apk add --no-cache --virtual .build-deps build-base git

# Cache-friendly: install gems before copying the rest of the sources.
COPY Gemfile ./
RUN bundle config set --local path '/usr/local/bundle' \
    && bundle install --jobs 4 --retry 3

# Now bring in the actual docs.
COPY . .

ENV JEKYLL_ENV=production
RUN bundle exec jekyll build \
        --source . \
        --destination /out \
        --baseurl "${BASE_URL}"

# Drop build deps after build; we don't need them in the artefact.
RUN apk del .build-deps

# ---- Runtime stage: nginx serving the built HTML ----
# nginx-unprivileged runs as the `nginx` user (UID 101), listens on port 8080
# by default, and ships no setuid binaries.
FROM --platform=$TARGETPLATFORM nginxinc/nginx-unprivileged:stable-alpine AS runtime
LABEL org.opencontainers.image.source="https://github.com/Dim145/lunasea"
LABEL org.opencontainers.image.title="lunasea-docs"
LABEL org.opencontainers.image.description="LunaSea documentation site (Jekyll + Just the Docs)"

COPY --from=build --chown=nginx:nginx /out /usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- --spider http://127.0.0.1:8080/ || exit 1
