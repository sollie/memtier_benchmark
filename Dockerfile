FROM alpine:latest as builder
RUN \
  apk add \
  make g++ autoconf automake libtool pkgconfig \
  pcre-dev libevent-dev zlib-dev openssl-dev
COPY . /src
WORKDIR /src
RUN autoreconf -ivf && ./configure && make && make install

FROM alpine:latest
LABEL Description="memtier_benchmark"
COPY --from=builder /usr/local/bin/memtier_benchmark /usr/local/bin/memtier_benchmark
RUN \
  apk add libstdc++ pcre libevent zlib openssl bash

ENTRYPOINT ["tail", "-f", "/dev/null"]
