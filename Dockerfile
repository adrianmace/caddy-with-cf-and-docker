FROM caddy:2.6.4-builder@sha256:67cdfd800e464f5be06a8ae1b5df572fae765bcc5f1b765d1e55131cc1c4f1ec AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:f3334d75c34fa0c149f0888d9a251e33e3e12e275eecd363c824edfbb7b0e310

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
