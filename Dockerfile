FROM opensuse/tumbleweed as build
RUN zypper -n update && zypper -n install wget tar xz gcc openssl-devel make R-base-devel pcre-devel lzma-devel \
libbz2-devel zlib-devel libicu-devel
RUN mkdir -p /build && cd /build && \
wget https://www.monetdb.org/downloads/sources/Nov2019-SP1/MonetDB-11.35.9.tar.xz && \
tar xf MonetDB-11.35.9.tar.xz && cd MonetDB-11.35.9 && ldconfig -v && ./configure --enable-rintegration=yes && make

FROM opensuse/tumbleweed as application
RUN zypper -n update && zypper -n install make R-base
COPY --from=build /build/MonetDB-11.35.9 /build
RUN cd /build && make install && rm -rf /build && zypper clean -a && ldconfig -v
RUN mkdir -p /monetdb && echo $'#!/usr/bin/env sh\n\
if [ ! -d /monetdb/dbfarm ]; then\n\
  monetdbd create /monetdb/dbfarm\n\
fi\n\
if [ ! -d /monetdb/dbfarm/db ]; then\n\
  monetdbd start /monetdb/dbfarm\n\
  monetdb create db\n\
  monetdb release db\n\
  monetdb set embedr=true db\n\
  monetdbd stop /monetdb/dbfarm\n\
fi\n\
monetdbd set listenaddr=0.0.0.0 /monetdb/dbfarm\n\
monetdbd start -n /monetdb/dbfarm'\
>> /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh
