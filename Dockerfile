# Build stage
FROM --platform=$BUILDPLATFORM caddy:2-builder-alpine AS builder

ARG SELECTED_VERSION
RUN test -n "$SELECTED_VERSION" || (echo "SELECTED_VERSION build argument not set" && false)
# Override base image's env var
ENV CADDY_VERSION=${SELECTED_VERSION}

ARG TARGETOS
ARG TARGETARCH
ARG CUSTOM_CORE
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 xcaddy build \
    $([ -n "$CUSTOM_CORE" ] && echo "--with github.com/caddyserver/caddy/v2=$CUSTOM_CORE") \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/mholt/caddy-events-exec \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

# Runtime creation stage
FROM caddy:2-alpine

ARG SELECTED_VERSION
# Override base image's env var
ENV CADDY_VERSION=${SELECTED_VERSION}
# Override base image's labels
LABEL org.opencontainers.image.source="https://github.com/ZingyAwesome/caddy-docker"
LABEL org.opencontainers.image.version=${SELECTED_VERSION}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
