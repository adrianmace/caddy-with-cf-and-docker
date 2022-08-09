FROM caddy:2.5.2-builder@sha256:54d703369ccb33ea94cf5c71b62c54e39342bd7f0cfd52c5068f2852575507b2 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:6d47dfbdde8d6b271f5c8e177fe723a1373e9a9c08c0fb62fef447afa4683979

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
