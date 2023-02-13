FROM debian:bullseye-slim
RUN apt-get update &&  \
    apt-get install -y wget xz-utils bison cmake gcc pkg-config python3 &&  \
    apt-get install -y python3-dev libbz2-dev libpcre3-dev libreadline-dev liblzma-dev zlib1g-dev
RUN mkdir /tmp/build &&  \
    cd /tmp/build &&  \
    wget https://www.monetdb.org/downloads/sources/Sep2022-SP2/MonetDB-11.45.13.tar.xz &&  \
    tar -xf MonetDB-11.45.13.tar.xz &&  \
    cd MonetDB-11.45.13 &&  \
    cmake -DSTRICT=ON -DINT128=ON -DGEOM=ON -DPY3INTEGRATION=ON -DWITH_BZ2=ON -DWITH_PCRE=ON -DWITH_READLINE=ON -DWITH_LZMA=ON -DWITH_ZLIB=ON . &&  \
    cmake --build . &&  \
    cmake --build . --target install &&  \
    cd / &&  \
    rm -r /tmp/build && \
    apt-get remove -y --purge --auto-remove wget xz-utils bison cmake gcc pkg-config && \
    apt-get remove -y --purge --auto-remove python3-dev libbz2-dev libpcre3-dev libreadline-dev liblzma-dev zlib1g-dev && \
    useradd --create-home --user-group monetdb &&  \
    mkdir -p /var/lib/monetdb &&  \
    chown monetdb:monetdb /var/lib/monetdb
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
USER monetdb:monetdb
VOLUME /var/lib/monetdb
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 50000