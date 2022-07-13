FROM caddy:2-builder@sha256:80ec4767d09e582df6543a1e3580002d080c009d7a50e1d2a6d1963e604e0af2 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:921cd018be8a0979ce31d0c0383e309b3de4c60cbe96251c551eeaecfc7fac2d

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
