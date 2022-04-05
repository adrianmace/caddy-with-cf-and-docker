FROM caddy:2-builder@sha256:844f9974051aee8153273069c8ddd374608c3400f4c01db3ce01902fe4a188ce AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:b790e6358cdc76f0356f391b1823d89eda699b6feaa9c70e008ce95ef9bf11fd

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
