FROM caddy:2.6.2-builder@sha256:c008c539daa9d19648867b60613e000ffc76d8e86b8dcbd588c442ca3efca937 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:60d8d32f793121f7ff31adb9ffdacfdd30c7c193eb5000af8ae0efb39b0bff4e

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
