FROM caddy:2.5.2-builder@sha256:54d703369ccb33ea94cf5c71b62c54e39342bd7f0cfd52c5068f2852575507b2 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:0c53d53e8522cf98d902105f02bef22e92a619d40a55c445bfb44b459f284f9b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
