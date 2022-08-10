FROM caddy:2.5.2-builder@sha256:b25475c9dbedf0d1242aabb847cf3cbfb7e8bfa4d51ecd1f7629d7b6716e82d6 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:38d5a90c24b73546f1921429fd79ca9ef1e89d10caf7a0c487955fa5fc212e38

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
