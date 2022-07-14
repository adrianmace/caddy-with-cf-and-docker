FROM caddy:2.5.2-builder@sha256:f68592219340bb743bb752f7c4c5711a95693066900a45c88ef1a99fd59f7a99 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:343a268d45b94fb60575c5a477f4cf3a62b24e1c1dc6c63a25488c4871c98c69

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
