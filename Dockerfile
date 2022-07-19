FROM caddy:2.5.2-builder@sha256:5fb258b0bf60c7ad7f363023b2ce7e5d55e7e64feddbcfc5a3d0186e36fe653b AS builder

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
