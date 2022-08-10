FROM caddy:2.5.2-builder@sha256:bb4ffc190f522d40ab390008e988db6e281e629e2363deb7e741a012d46d6488 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:04275786ace772b2bd49b3be4c692739aa6e3912b7cee35ac3e25dae660fba4a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
