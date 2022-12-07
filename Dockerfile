FROM caddy:2.6.2-builder@sha256:ffe4f5070feaddc4d9fff9e3abcdd840d26c1578f9a7e09eba9809e3e3a03ab9 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:50743fc6130295e9e8feccd8b2f437d8c472f626bf277dc873734ed98219f44f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
