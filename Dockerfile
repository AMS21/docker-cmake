FROM alpine:3.24 AS builder

ARG VERSION

ENV CFLAGS="-w -O3 -flto -pipe -Wno-error=incompatible-pointer-types" \
    CXXFLAGS="-w -O3 -flto -pipe -Wno-error=incompatible-pointer-types"

RUN apk update && \
    apk add --no-cache gcc git g++ linux-headers make openssl-dev && \
    rm -rf /var/cache/apk/*
RUN git clone --depth 1 --branch "${VERSION}" https://github.com/Kitware/CMake.git
ADD patches/ patches/
RUN cd CMake && \
    if [[ -d "../patches/${VERSION}" ]]; then git apply ../patches/${VERSION}/*.patch; fi && \
    ./bootstrap --parallel=$(nproc) && \
    make -j $(nproc) && \
    make install
RUN rm -rf /usr/local/share/cmake-*/Help && \
    rm -rf /usr/local/doc/cmake-*/

FROM alpine:3.24

RUN apk update && \
    apk add --no-cache gcc g++ make && \
    rm -rf /var/cache/apk/*
COPY --from=builder /usr/local /usr/local
