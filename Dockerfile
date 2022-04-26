FROM caddy:2-builder@sha256:e67e63adda0c63a6e2897ccbe67d257d363986bb0add0a87460e7e5b21f68fcb AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:e42e57a219aa11138f3f147fb0c80b364c57fb063f85568664136ca9f7dd0048

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
