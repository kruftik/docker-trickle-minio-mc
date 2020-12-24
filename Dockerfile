FROM alpine:latest

ENV TRICKLE_VERSION=596bb13f2bc323fc8e7783b8dcba627de4969e07
ENV TRICKLE_SHA256SUM=a4111063d67a3330025eea2f29ebd8c8605e43cc1be0bf384b48f0eab8daf508

#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# trickle
#  work around issue #16:  https://github.com/mariusae/trickle/issues/16
RUN set -eux; \
    apk add --no-cache libcurl libtirpc-dev libevent \
    && apk add --no-cache --virtual .build-deps curl make automake autoconf libtool alpine-sdk libevent-dev; \
    cd /tmp; \
    curl -L -o trickle.tgz https://github.com/mariusae/trickle/archive/${TRICKLE_VERSION}.tar.gz; \
    echo "$TRICKLE_SHA256SUM  trickle.tgz" | sha256sum -c -; \
    tar xvzf trickle.tgz; \
    cd "trickle-${TRICKLE_VERSION}"; \
    export CFLAGS=-I/usr/include/tirpc; \
    export LDFLAGS=-ltirpc; \
    autoreconf -if; \
    ./configure; \
    make install-exec-am install-trickleoverloadDATA; \
    rm -rf /tmp/*; \
    apk del .build-deps;

RUN wget -O /usr/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc \
    && chmod +x /usr/bin/mc
