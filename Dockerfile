FROM caddy:2.6.4-builder@sha256:5d25acee5683b45e637dff3a8799b8ae6ca58f33fdb1c89db14dd0840c318bd1 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.4@sha256:ef6ed6e22b469efd5051e1c4cee221d3a0ebebea14bbb5898c8fb4dc70d12d12

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
