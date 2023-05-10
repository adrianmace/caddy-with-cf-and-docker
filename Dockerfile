FROM caddy:2.6.4-builder@sha256:15552d8d1788ccdcce4a31797f7fd82ace7c7cc25656860162eafd9fb93a095f AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:bc23ee7f830ab9d029e5469e82a3e36f8c401001c2c8a5a6d919a82668d8087b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
