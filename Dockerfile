FROM alpine:3.21

ARG VERSION

ADD patches/ patches/

RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache gcc g++ make git linux-headers openssl-dev && \
    git clone --depth 1 --branch "${VERSION}" https://github.com/Kitware/CMake.git && \
    cd CMake && \
    if [[ -d "../patches/${VERSION}" ]]; then git apply ../patches/${VERSION}/*.patch; fi && \
    CFLAGS="-w -O3 -flto -pipe -Wno-error=incompatible-pointer-types" \
    CXXFLAGS="-w -O3 -flto -pipe -Wno-error=incompatible-pointer-types" \
    ./bootstrap --parallel=$(nproc) && make -j $(nproc) && \
    make install && \
    cd .. && \
    rm -rf CMake && rm -rf patches && \
    apk del --purge --no-cache git linux-headers openssl-dev && \
    rm -rf /var/cache/apk/*
