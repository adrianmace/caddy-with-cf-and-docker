FROM caddy:2.7.2-builder@sha256:725ed1d6931517a4493aec7f07b8ac4920b51b94292a5cb37144fce04c3ed7fb AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.2@sha256:58791028dd53c7eb6768f601413cb97e7f33b039184db2f673bc5ad98db820b0

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
