FROM caddy:2.6.2-builder@sha256:24b5f53bbe199347ef92c95ba6ddfaee9cbbbec1293ab335e5eb5e2d6759a054 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:5ac7be68f51bf394969efc213b14e720e9cde8405a11daeae0dd186c5e561692

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
