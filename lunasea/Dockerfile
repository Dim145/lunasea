# syntax=docker/dockerfile:1.6

# ---- Build stage ----
FROM --platform=$BUILDPLATFORM debian:trixie-slim AS build

ARG FLUTTER_VERSION=3.41.9
ARG FLAVOR=stable
ARG BUILD=9999999999
ARG COMMIT=master

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git unzip xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 -s /bin/bash builder

USER builder
WORKDIR /home/builder

ENV FLUTTER_HOME=/home/builder/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:/home/builder/.pub-cache/bin:${PATH}"
ENV PUB_CACHE=/home/builder/.pub-cache

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    && git config --global --add safe.directory ${FLUTTER_HOME} \
    && flutter --version \
    && flutter config --no-analytics \
    && flutter precache --web

WORKDIR /home/builder/lunasea

# Resolve dependencies (cache-friendly: only pubspec changes invalidate this layer)
COPY --chown=builder:builder pubspec.yaml ./
RUN flutter pub get

# Bring in the rest of the sources
COPY --chown=builder:builder . .

# Run code generators required before `flutter build`. Modern build_runner
# deletes conflicting outputs by default, so the `--delete-conflicting-outputs`
# flag was removed.
RUN FLAVOR=${FLAVOR} COMMIT=${COMMIT} BUILD=${BUILD} \
        dart run environment_config:generate \
    && dart scripts/generate_localization.dart \
    && dart run build_runner build

# Build the web release with Wasm support. Flutter ships both Wasm and JS
# entrypoints in the same artifact; `flutter_bootstrap.js` picks Wasm when the
# server sends cross-origin isolation headers (we do — see nginx/default.conf)
# and falls back to JS otherwise.
RUN flutter build web --release --wasm \
        --dart-define=FLAVOR=${FLAVOR} \
        --dart-define=COMMIT=${COMMIT} \
        --dart-define=BUILD=${BUILD}

# ---- Runtime stage ----
# nginx-unprivileged runs as the `nginx` user (UID 101), listens on port 8080
# by default, and has no setuid binaries. No `USER root` step is ever needed
# in this image.
FROM --platform=$TARGETPLATFORM nginxinc/nginx-unprivileged:stable-alpine
LABEL org.opencontainers.image.source="https://github.com/JagandeepBrar/lunasea"
LABEL org.opencontainers.image.title="lunasea-web"
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build --chown=nginx:nginx /home/builder/lunasea/build/web /usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -qO- --spider http://127.0.0.1:8080/ || exit 1
