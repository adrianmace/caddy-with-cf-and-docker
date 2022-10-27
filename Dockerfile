FROM caddy:2.6.2-builder@sha256:7cf80f3c5f352a69fb9d4601b316307ba16ea4fac32fafcd9e327821f39b391f AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:8adb91669d868a19cb0f5d8eadcb181e86b87aebf868efa95be761aafedbeef1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
