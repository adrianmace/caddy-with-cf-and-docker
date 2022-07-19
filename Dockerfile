FROM caddy:2.5.2-builder@sha256:955440550de4c97ed7152952a1240d19ecc9d7f4bacabd9ccba9bb0668cc7a52 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:f51603577fef8abe01dfda4b5ef85b3acf2844a6b3d0db873f5119f57db5de57

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
