FROM caddy:2.5.2-builder@sha256:eb737e055c0653638228c687b4ddfe39ce4d046cb0a23687842ca3efbc22ec2e AS builder

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
