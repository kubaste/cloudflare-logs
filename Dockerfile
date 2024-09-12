FROM openresty/openresty:alpine


RUN apk add --no-cache wget tar build-base lua5.1-dev openssl-dev git zlib-dev busybox-extras


RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz && \
    tar zxpf luarocks-3.11.1.tar.gz && \
    cd luarocks-3.11.1 && \
    ./configure --with-lua=/usr/local/openresty/luajit/ --lua-suffix=jit --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
    make build && make install


RUN luarocks --version

RUN luarocks install lua-zlib

RUN luarocks install lua-resty-http && \
    luarocks install lua-resty-logger-socket


COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx.conf /etc/openresty/nginx/nginx.conf


EXPOSE 80


CMD ["openresty", "-g", "daemon off;"]
