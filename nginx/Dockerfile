FROM openresty/openresty:bullseye

# Install dependencies and the lua-resty-http module
RUN apt-get update && \
    apt-get install -y luarocks && \
    luarocks install lua-resty-http && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["openresty", "-g", "daemon off;"]
