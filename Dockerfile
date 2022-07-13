FROM caddy:2-builder@sha256:fa9e752c0ced5534bcf69063efc77352c02ee92b54c9f506f23edc4f1b4f1dc9 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:bc291fea772b6743bf74fe13865896fa2cae05b21de646f6fa8770f0a6cc6030

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
