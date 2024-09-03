FROM debian:bullseye-slim

ARG FRP_VERSION

WORKDIR /app
RUN apt update
RUN apt install -y curl tar
RUN curl -L https://github.com/GaiaNet-AI/gaia-frp/releases/download/${FRP_VERSION}/gaianet_domain_${FRP_VERSION}_linux_amd64.tar.gz -o /frp.tar.gz
RUN tar -xzf /frp.tar.gz --strip-components=1 -C /app
RUN rm /frp.tar.gz

CMD ["./frps", "-c", "./conf/frps.toml"]

