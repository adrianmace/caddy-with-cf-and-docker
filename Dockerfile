FROM caddy:2.7.2-builder@sha256:564f2fbbbb6828a69ffe1ef751eac50dc2408e471d88424d2a38743e20edc532 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.2@sha256:89213bb94f8a60ebf0554ffe4a45c1af65321140246d34a689e641dae233b063

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
