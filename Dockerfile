FROM caddy:2.5.2-builder@sha256:7ad1d0c4df755ede2030355ce1a3088c2aa2baae1700ce9ffb59674f096a0ed3 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:92c7f3196655a192f3d289a5b254bf9753b32ba34ebdb56e0f1614d54ec80916

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
