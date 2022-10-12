FROM caddy:2.6.1-builder@sha256:fcf593a017309d558d52b3b2bca466dbe725816b99c58bf3a22b110fa5b5a017 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.1@sha256:efeb98cef01cdd48512e21443eecf0b897ab1e4d68666b54c60bb83a9b8c6fa1

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
