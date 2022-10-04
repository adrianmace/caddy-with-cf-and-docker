FROM caddy:2.6.1-builder@sha256:7074b59735ddf6643ff6d00f59901a9c46478911fb6f0b8a83218e8a755cd7dc AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.1@sha256:faadebac07e5c9daaa97adf528801d228c01d706a6755ab0c082acc4702e25de

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
