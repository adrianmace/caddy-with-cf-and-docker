FROM caddy:2-builder@sha256:ee711780882d502f4d5cf0795a6cab034cf93588efd2d187df6f6e75d5314c93 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:8465769cd8d9425547872c0f2d41c3e9ff1d1b4282d6a7b219b985f7526b467e

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
