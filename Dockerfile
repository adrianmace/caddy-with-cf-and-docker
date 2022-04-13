FROM caddy:2-builder@sha256:c3fe20ea63efe1eb2c4c2346e206b2b1de903d4b176001a28a101b2a8ced0968 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2@sha256:50a38e32a96b709de9e5112eb1909b7f03fab16959929da71f342c5bdb114641

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
