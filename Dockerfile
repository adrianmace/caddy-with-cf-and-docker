FROM caddy:2.5.2-builder@sha256:8e17d72ff68a3b381ae425a6d34306fbb5647d913139abae8cc38cdab4683e52 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.5.2@sha256:d7836d081bdc21c3a5a61e8ffd8c421304aebd548eeec538feb64f444520cbb6

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
