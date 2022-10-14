FROM caddy:2.6.2-builder@sha256:fe2000a6ddc18a11b875c73e8d7562c6092ea50ca00e11327e6b276805b3d6b5 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:75a72127706dbf3794c65485f56d73fece8bbfe9048c43e77b7cb7ec6b575e4a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
