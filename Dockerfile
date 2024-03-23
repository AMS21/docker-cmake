FROM ubuntu:latest

ARG VERSION

# Update apt
RUN apt-get update && apt-get upgrade -y

# Install build dependencies
RUN apt-get install make gcc g++ git ca-certificates libssl-dev --no-install-recommends -y

# Update certificates
RUN update-ca-certificates

# Clone repository
RUN git clone --depth 1 --branch "${VERSION}" https://github.com/Kitware/CMake.git

# Build and install cmake
RUN cd CMake && ./bootstrap && make -j && make install

# Verify cmake is installed
RUN cmake --version

# Cleanup
RUN rm -rf cmake && apt-get clean
