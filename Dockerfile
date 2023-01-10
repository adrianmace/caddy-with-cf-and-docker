FROM caddy:2.6.2-builder@sha256:058b31ffd6967b23c29f11897ddeee595fd15156f3c17131c609b8f200ebd084 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:39f1da8bd9f6405dc7f085062d532aee5abb3cb64a7526c5f468e15aa2525f89

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
