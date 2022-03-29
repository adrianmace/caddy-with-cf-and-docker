FROM caddy:2-builder@sha256:d68bc5f41d6aa3c85abcf9601715ad226a9a29f9e33b7d47c6d963804a3777cd AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:f985dbaaac8f07bd99f55f4117a7c1cb2bf14d9263844bcce17baafa45511e6f

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
