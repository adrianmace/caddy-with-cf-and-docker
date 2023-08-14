FROM caddy:2.7.3-builder@sha256:72235016961770347eb1ca2771c13e5e406c0091e3584d0bc7dd6ffbd481abd5 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.3@sha256:0da93d63c5b3af38288e909b953bd8cdcf12537c27ff219aac46c6a01775cbdb

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
