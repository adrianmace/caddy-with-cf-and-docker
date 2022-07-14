FROM caddy:2.5.2-builder@sha256:f21614501191f698acc099a7496c35362117267af5656686c2744ee99424f058 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:68816fe4233117d9f1d4f58078a6be662d9a3028ec6a8318a648c6e01d53aa6f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
