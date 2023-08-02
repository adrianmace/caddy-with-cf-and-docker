FROM caddy:2.6.4-builder@sha256:04af8a461ece26fc179180fa014604ae116dccc17e9689359a91efa769a9090f AS builder

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
