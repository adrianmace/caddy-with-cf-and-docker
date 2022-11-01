FROM caddy:2.6.2-builder@sha256:9a395d60c9cba0036b919495f7637be3fafb0a97459ee970f1738e0252dfa2f7 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:d3e5e175b10a2a5b66be9570ed9867aeb77af8eca7a14b6033dcde2c9f6fee6f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
