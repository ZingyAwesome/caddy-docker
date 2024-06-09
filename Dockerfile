FROM caddy:2.8.4-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/mholt/caddy-events-exec \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-ratelimit \
    --with github.com/RussellLuo/caddy-ext/layer4 \
    --with github.com/ueffel/caddy-brotli \
    --with github.com/WeidiDeng/caddy-cloudflare-ip

FROM caddy:2.8.4-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN addgroup -g 950 -S caddy; \
    addgroup -g 951 -S certs; \
    adduser -u 950 -D -S -G caddy caddy; \
    adduser caddy certs;

USER caddy
