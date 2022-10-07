FROM caddy:2.6.1-builder@sha256:ceaa6daa2d796b97df65cd69a2af00a87808d8f11610563036fb6e7a70419cee AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.1@sha256:702db356e8f6a035d72ec1ddc5544f0f31b83f2d6791175a9d3464aaff5df670

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
