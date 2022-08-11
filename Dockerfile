FROM caddy:2.5.2-builder@sha256:ab0bf6138855c0a3bfeacac64819d3e735a2f230a3265d3bc96d3f6ad64f2e9b AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:740c1c9e461ea1f8a54d7512b35cd31927c814c86455f71e7e8e0c2b6ee423a2

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
