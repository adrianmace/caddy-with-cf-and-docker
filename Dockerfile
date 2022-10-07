FROM caddy:2.6.1-builder@sha256:6a8b8935d03c6924e34ce2e2af494e28bb0dd0bec4a6d1bfa56811fb385f058b AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.1@sha256:9a93e2d2418b6d53e80e3b9230cdd8df68c9f4a3562cab5ee2b1c14cbaa08ad1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
