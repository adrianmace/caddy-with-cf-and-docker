FROM caddy:2.5.2-builder@sha256:f68592219340bb743bb752f7c4c5711a95693066900a45c88ef1a99fd59f7a99 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:bfe8cc006449d4b4d4a06d9eb12e2655645114edea9b9de7b6f19a4e68f918fb

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
