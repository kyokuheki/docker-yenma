FROM alpine:latest as builder
LABEL maintainer Kenzo Okuda <kyokuheki@gmail.comt>
ENV LANG="en_US.UTF-8"

#https://github.com/iij/yenma/blob/master/INSTALL.ja
#http://enma.sourceforge.net/

RUN set -x \
 && apk add --no-cache \
    build-base \
    curl \
    ldns-dev \
    libmilter-dev \
    openssl-dev

#ADD https://github.com/iij/yenma/archive/master.tar.gz /yenma

RUN set -x \
 && curl -sSL https://github.com/iij/yenma/archive/master.tar.gz | tar zxvf - -C / \
 && cd /yenma-master \
 && ./configure \
 && make install

FROM alpine:latest
LABEL maintainer Kenzo Okuda <kyokuheki@gmail.com>
ENV LANG="en_US.UTF-8"

COPY --from=builder /usr/local/bin/spfeval /usr/local/bin/spfeval
COPY --from=builder /usr/local/libexec/yenma /usr/local/libexec/yenma
COPY --from=builder /usr/local/lib/libsauth.a /usr/local/lib/libsauth.la /usr/local/lib/libsauth.so.0.0.0 /usr/local/lib/
COPY --from=builder /usr/local/etc/yenma.conf /etc/yenma/yenma.conf

RUN set -x \
 && ln -svf libsauth.so.0.0.0 /usr/local/lib/libsauth.so.0 \
 && ln -svf libsauth.so.0.0.0 /usr/local/lib/libsauth.so

RUN set -x \
 && apk add --no-cache \
    ldns \
    libmilter \
    monit \
    netcat-openbsd \
 && mkdir -p /etc/yenma

COPY monitrc /etc/monitrc
ADD https://publicsuffix.org/list/public_suffix_list.dat /etc/public_suffix

RUN set -x \
 && chmod 600 /etc/monitrc

EXPOSE 10025/tcp
VOLUME ["/etc/yenma"]

CMD set -x; \
    ln -svf /var/run/dev/log /dev/log; \
    /usr/local/libexec/yenma -c /etc/yenma/yenma.conf \
 && monit -vvIB

HEALTHCHECK --interval=60s --timeout=5s \
  CMD monit -B status yenma | awk '/^  status/{print $2;exit ($2!="OK")}' || exit 1
