FROM caddy:2-builder@sha256:844f9974051aee8153273069c8ddd374608c3400f4c01db3ce01902fe4a188ce AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:e194ce5ce4250e299ea693b766c66a4d6a03ee60d4abedbcb19ae7f716c4f1da

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
