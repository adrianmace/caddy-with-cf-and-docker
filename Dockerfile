FROM caddy:2.6.2-builder@sha256:2b62f031e88d688df0cf0fc8537d012d1bf36cecacc931fda1487a5aefe2067e AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:d3e5e175b10a2a5b66be9570ed9867aeb77af8eca7a14b6033dcde2c9f6fee6f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
