FROM caddy:2-builder@sha256:d6ef3b3bc21ad5ee1f99ce55a38dd67fa1ea4cc5af2bd75a032a7f3a5e43ee44 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:607a656e512737b5c4e7f7254dd49e1688b721915fb9ad1611812a12361d7d69

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
