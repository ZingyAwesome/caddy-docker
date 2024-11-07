FROM caddy:2.9.0-beta.3-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/mholt/caddy-events-exec \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:2.9.0-beta.3-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
