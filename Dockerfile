FROM ubuntu:22.04
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime &&  \
    apt-get update &&  \
    apt-get install -y bison cmake gcc libssl-dev pkg-config python3 python3-dev python3-numpy python3-numpy-dev  \
      wget r-base r-base-dev libbz2-1.0 libbz2-dev uuid uuid-dev libpcre3 libpcre3-dev libreadline8 libreadline-dev  \
      liblzma5 liblzma-dev zlib1g zlib1g-dev && \
    mkdir /tmp/build && \
    cd /tmp/build && \
    wget https://www.monetdb.org/downloads/sources/Jan2022-SP1/MonetDB-11.43.9.tar.xz && \
    tar -xf MonetDB-11.43.9.tar.xz && \
    cd MonetDB-11.43.9 && \
    cmake . -DWITH_BZ2=ON -DINT128=ON -DPY3INTEGRATION=ON -DRINTEGRATION=ON -DWITH_LZMA=ON -DWITH_PCRE=ON  \
      -DWITH_READLINE=ON -DWITH_UUID=ON -DWITH_ZLIB=ON && \
    cmake --build . &&  \
    cmake --build . --target install && \
    cd / && \
    rm -r /tmp/build &&  \
    apt-get remove -y --purge --auto-remove bison cmake gcc libssl-dev pkg-config wget r-base-dev python3-dev  \
      python3-numpy-dev libbz2-dev uuid-dev libpcre3-dev libreadline-dev liblzma-dev zlib1g-dev &&  \
    apt-get clean &&  \
    mkdir -p /monetdb
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
VOLUME /monetdb
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 50000