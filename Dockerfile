FROM caddy:2.6.2-builder@sha256:fd1f735574037761ab72c12bb75d1b9ac64d96b5465e27756c306b12f681451b AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:16f4d944907ac8adc93e11df3e4d1b8405d42e4f45e6bc1aae4eb1119552ee79

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
