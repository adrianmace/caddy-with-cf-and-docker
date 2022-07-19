FROM caddy:2.5.2-builder@sha256:d77a2e50876feb94eaa5c322a827e6ce4eabe8d0657175f94f33de356e2b8932 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:f51603577fef8abe01dfda4b5ef85b3acf2844a6b3d0db873f5119f57db5de57

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
