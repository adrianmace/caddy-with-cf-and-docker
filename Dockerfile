FROM caddy:2.6.4-builder@sha256:a87e453514ba9f35e8233d367ab270a09fb7e0fb084e6e525913cc5f3b81f595 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:8c4f513466c37e1a7f0dd83ec05a4ef80f78abc129d323b880aa3400fccff979

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
