FROM caddy:2.5.2-builder@sha256:1a8f153ebe56283c4d5168d92c049b00ae1c635248f99295c4c106ccfad3012f AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:c2aa034bd91237e02c80e030f1366fe0e20c88dfc6b9eac5c3cfefdc447b7bc9

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
