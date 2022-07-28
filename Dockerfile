FROM caddy:2.5.2-builder@sha256:1a5b266bad59ada954eabcfdf6a0d3dfdd005e71d4e37523aec4d9dbd3d69cd1 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:7faf730343c6bd50150b13b73bac1f97886a30ae15f145e5d301c8299949bb52

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
