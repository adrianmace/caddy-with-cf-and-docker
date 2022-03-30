FROM caddy:2-builder@sha256:8807a8ebea5e7ac4946ecde2864660b1028e943661ef1af880d9666ff3ed140a AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:f4840526af7bf068e5e8941e190bb42c0c8e98f10b2ee576d92ff85cba9d368d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
