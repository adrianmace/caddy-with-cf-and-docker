FROM caddy:2.6.2-builder@sha256:dcad339cc1f713b11dfe76aaed63a15a3646249d925a8bac71b6bcff07b83b84 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:4cf893ac9f7813089b200ab36cd23478a25641a0f75857e42dcc0aea6ba0f48d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
