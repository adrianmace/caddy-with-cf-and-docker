FROM caddy:2.5.2-builder@sha256:5cb6e41b71471ceed27e4028f22fe74431ed2f0c9070f43a0ff0a5e7cdce082a AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:3def24d641ef392941e291c59dbc97f8d7ae686afe67f43b00412772170c82e2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
