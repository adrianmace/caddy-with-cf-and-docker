FROM caddy:2.6.4-builder@sha256:e849a3ca3945f7122242440191cec8d4d568ac2f42add780ac7b4d22b5356c88 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:cb9a70e2fe64b1f0a871628e2fa71efcfb3f632dacc0a210ca8d484445cca70a

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
