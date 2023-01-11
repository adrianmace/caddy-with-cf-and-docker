FROM caddy:2.6.2-builder@sha256:1e10b4f7eb2673ccf0b99079598187496112e4258c09e1a49164f762056f6826 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.6.2@sha256:39f1da8bd9f6405dc7f085062d532aee5abb3cb64a7526c5f468e15aa2525f89

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 2019 443 80
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
