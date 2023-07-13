FROM caddy:2.6.4-builder@sha256:5ddd55fb783222b373e356894225461a2ed0ede31e79b34479f9740cac5b8d18 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:f03baefceddeb48279d4cb77fbb65a555e5f72e4d5a0e631a39728c7fb20e94c

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
