FROM caddy:2-builder@sha256:81fcae6c8754b60a6694fa9de78ad16f624bf2746f50e224dbd447d197597ae5 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:eb2cce28a50cb1f20f1e4a13181f3e453e58d20999cffa7750222d9907023b6b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
