FROM caddy:2.6.1-builder@sha256:180a269f1aac17ce43c4c7ddebd1432fcfe326e78d56f39ff70bd0cb0bd36878 AS builder

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
