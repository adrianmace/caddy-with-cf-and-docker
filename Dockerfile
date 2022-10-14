FROM caddy:2.6.2-builder@sha256:88590d2c6108fcd2c7fd9e1af0fe1138e9dfe340f6d310ea4104b19ccc1504c0 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:a2ab9b4da81fb5793c09308f6353dec3d5aa70255288aa5a9390cf5333e74935

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
