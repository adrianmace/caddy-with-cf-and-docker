FROM caddy:2.6.4-builder@sha256:4e7bfc1f38f54592489329c068791884d53c7261d9cb55cc5f1fe7114dfe8095 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:60fb54d36b4b56b655fbcea432b0057ecc24f68d3a9ff800c695886be48e368d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
