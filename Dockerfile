FROM alpine:latest

ARG VERSION

RUN apk update && apk upgrade --no-cache \
    && apk add --no-cache gcc g++ make git linux-headers openssl-dev \
    && git clone --depth 1 --branch "${VERSION}" https://github.com/Kitware/CMake.git \
    && cd CMake && ./bootstrap --parallel=$(nproc) && make -j $(nproc) && make install \
    && cd .. && rm -rf CMake
