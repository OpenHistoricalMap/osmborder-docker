from ubuntu:16.04

#install prerequisites
RUN apt-get -q update && \
    apt-get -q -y install git wget curl build-essential cmake osmium-tool s3cmd awscli \
    zlib1g-dev libbz2-dev libboost-all-dev libicu-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/ /var/cache/apt/ /var/cache/debconf/    

RUN git -c advice.detachedHead=false \
    clone --single-branch --depth 1 -b v1.6.3 \
    https://github.com/mapbox/protozero.git && \
    cd protozero && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd && \
    rm -rf /protozero

RUN git -c advice.detachedHead=false \
    clone --single-branch --depth 1 -b v2.14.0 \
    https://github.com/osmcode/libosmium.git && \
    cd libosmium && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cp -r /libosmium/include/utf8* /usr/local/include/ && \
    cd && \
    rm -rf /libosmium

RUN git -c advice.detachedHead=false \
    clone --single-branch --depth 1 -b v0.1.0-ohm \
    https://github.com/OpenHistoricalMap/osmborder.git && \
    cd osmborder && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    rm -rf /osmborder

ADD build-osm-borders.sh /
RUN chmod +x build-osm-borders.sh

CMD /build-osm-borders.sh
