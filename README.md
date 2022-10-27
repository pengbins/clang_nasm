# docker image with clang + cmake + nasm

[![docker](https://img.shields.io/docker/pulls/cbachhuber/clang.svg)](https://hub.docker.com/r/cbachhuber/clang/)

A docker image with clang, cmake and nasm. 

Base image is ubuntu 20.04.

Default clang version is clang-10.

Build with specify target clang version:

```
VER=12
docker build  --build-arg CLANG_VER=$VER  -t pengbin/clang_nasm:$VER .

```


