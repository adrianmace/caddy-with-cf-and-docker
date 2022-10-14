FROM caddy:2.6.2-builder@sha256:30173c31c6b81d39ddefe9f1d77e2df2730818dd47a4216926f82fe1f268600e AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:2b5eaec58eda7e9c2cbcf317c6e5fbfa5507a60d323967e24f686e3619330dc9

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
