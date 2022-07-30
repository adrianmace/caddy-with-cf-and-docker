FROM caddy:2.5.2-builder@sha256:37ab997194f43aa5affd809fbacb6c6ee3c474603937e307095234ba5222347d AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:5a90d69c3dfec48f2cb45a40f5311f85a36d88153cb028dfb3208ce652f65c64

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
