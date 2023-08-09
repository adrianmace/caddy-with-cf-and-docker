FROM caddy:2.7.2-builder@sha256:78bf7caca95bd334aad5a1b13a585f61701d703abd05b4814f5df92d29d7c09b AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.2@sha256:68f446c816258bc4b36219538be750e3e2850a937efb96561c6ab03d1181fc7b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
