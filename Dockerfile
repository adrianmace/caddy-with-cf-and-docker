FROM caddy:2-builder@sha256:72894b43fdfaf4cdc89cc821498bfc33dbdacebb2ce4b635ad0d465f746222fd AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:44b68b5f44fd95ac170dfc564a3d6e51da4592e453a210a87d4cd8c1adffc50d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
