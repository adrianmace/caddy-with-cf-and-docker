FROM caddy:2-builder@sha256:8d1b6d68563a8b6660976574d07eadd17a41d13e0ebf33d5a4da2116d654fef5 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:50a38e32a96b709de9e5112eb1909b7f03fab16959929da71f342c5bdb114641

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
