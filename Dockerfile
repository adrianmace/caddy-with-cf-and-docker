FROM caddy:2.6.4-builder@sha256:1ccfb44bf87b1d04e43b8bac2c2667785ac98f68df9532af70dc9d80443a2f7c AS builder

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
