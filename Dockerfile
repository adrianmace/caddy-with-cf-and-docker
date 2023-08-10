FROM caddy:2.7.2-builder@sha256:b183342c7ab2df5ecd73292433b0fdc18103a4a54cafb8e6dc5599d6e6071011 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.2@sha256:b6f9b2402441a2248ab1e0e3c48313d29abcc103fb74034a358faba4a644bc9c

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
