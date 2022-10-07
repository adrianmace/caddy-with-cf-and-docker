FROM caddy:2.6.1-builder@sha256:62e36cc4e78f53fc5bd4a264072c92500ac0e00cd681deb84f893f27982cc13d AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.1@sha256:bb9249b619c9158c1f7b962ba3089fe4169c061e9c9a7f52dcc6739153fc48f5

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
