# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:16.04 AS glibc-builder

ENV DEBIAN_FRONTEND=noninteractive 
ENV PREFIX_DIR=/usr/glibc-compat

ARG GLIBC_VER=2.17
ENV GLIBC_VERSION=$GLIBC_VER
ENV GLIBC_URL=https://ftpmirror.gnu.org/libc

RUN apt-get -q update \
	&& apt-get -qy install \
		bison \
		build-essential \
		gawk \
		gettext \
		openssl \
		python3 \
		texinfo \
		wget

RUN mkdir -p /glibc-build

RUN <<EOF cat >> /glibc-build/configparams
slibdir=${PREFIX_DIR}/lib
rtlddir=${PREFIX_DIR}/lib
sbindir=${PREFIX_DIR}/bin
rootsbindir=${PREFIX_DIR}/bin
build-programs=yes
EOF


RUN mkdir -p /glibc-build && cd /glibc-build  && \
    wget -qO- "${GLIBC_URL}/glibc-${GLIBC_VERSION}.tar.gz" | tar zxf - && \
    sed  -r -i "s/3\.79/4\./" "/glibc-build/glibc-$GLIBC_VERSION/configure" && \
    "/glibc-build/glibc-$GLIBC_VERSION/configure" \
    --prefix="${PREFIX_DIR}" \
    --libdir="${PREFIX_DIR}/lib" \
    --libexecdir="${PREFIX_DIR}/lib" \
    --enable-multi-arch  && \ 
     make -j $(nproc) && make install

ARG CLANG_VER=16
FROM ghcr.io/pengbins/clang_nasm:16-master  AS dist

ENV GLIBC_DIR=/usr/glibc-compat
ENV GLIBC_VERSION=$GLIBC_VER

COPY --from=glibc-builder $GLIBC_DIR/ $GLIBC_DIR/

