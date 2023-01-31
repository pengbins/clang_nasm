# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:20.04

ARG CLANG_VER=10
ENV CL_VER=$CLANG_VER

RUN <<EOF
set -e
set -x
apt-get update -qq 
DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        gnupg2 \
        software-properties-common \
        wget

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

add-apt-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${CL_VER} main"
#add-apt-repository "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-${CL_VER} main"

apt-get update -qq

DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends \
        libc++-${CL_VER}-dev \
        clang-$CL_VER \
        clang-tidy-$CL_VER \
        clang-format-$CL_VER \
        llvm-$CL_VER \
        nasm \
        git \
        cmake \
        make \
        tar \
        pkg-config \
        ccache \
        curl \
        unzip \
        zip \
        python3 \
        python3-pip

python3 -m pip install gcovr

ln -s /usr/bin/clang-$CL_VER /usr/bin/clang
ln -s /usr/bin/clang++-$CL_VER /usr/bin/clang++
ln -s /usr/bin/clang-tidy-$CL_VER /usr/bin/clang-tidy
ln -s /usr/bin/clang-format-$CL_VER /usr/bin/clang-format
ln -s /usr/lib/llvm-$CL_VER/lib/libc++abi.so.1.0 /usr/local/lib/libc++abi.so

apt-get remove  -qqy wget python3-pip
rm -rf /var/lib/apt/lists/*
EOF

ENV CC /usr/bin/clang-$CL_VER
ENV CXX /usr/bin/clang++-$CL_VER
RUN echo using clang-$CL_VER + nasm

