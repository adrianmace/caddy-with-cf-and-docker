FROM caddy:2.6.2-builder@sha256:1bfbc30b9fa0fe174661a0c039680b75fee83c3fdbeb8504faa1a4de574addce AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:1ef8771ba0e711f8d252ab410ec33b54f08e9e3c569f63526c95b18ecfd923c3

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
