FROM caddy:2.6.0-builder@sha256:cab8bc87b1d237053032dd54fc075655aa0eac1519d62fc5b906edbf7afe9b45 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.0@sha256:918c1a90862f95b1f8ea1b5cc869b0d2653bf0d6e18b0010771e17b96155403a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
