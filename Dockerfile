FROM caddy:2.6.0-builder@sha256:f189c12325221185dc1750e0ebcfa27154a0d6ac8c0c69e675767325028ab48c AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.0@sha256:a8fbf3cfbce0aa97bbc5e3b9b99df439f396aa6ec094d0f372415f7896ee1d16

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
