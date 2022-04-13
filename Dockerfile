FROM caddy:2-builder@sha256:c41bdf72cba4e0b7dea13a24c6a77d208ad4c56ba26ae6315e8b7298ee2911de AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:53e1462eb68d51b5b2995be1c5d0c631fa67824f3fe37d692fe73ca714a7236f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
