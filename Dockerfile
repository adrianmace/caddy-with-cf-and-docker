FROM caddy:2.6.4-builder@sha256:03528dde6453ddde8c0044d774a7286f2e2bc7f647b5686a9464cf9d13b36f66 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:ef6ed6e22b469efd5051e1c4cee221d3a0ebebea14bbb5898c8fb4dc70d12d12

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
