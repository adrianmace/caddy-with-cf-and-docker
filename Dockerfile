FROM caddy:2-builder@sha256:a32e530f13cf5aca802e43c9814858c0eba7c9830e7581b907ba6122be3c9cbc AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:eb2cce28a50cb1f20f1e4a13181f3e453e58d20999cffa7750222d9907023b6b

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
