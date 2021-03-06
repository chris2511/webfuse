ARG REGISTRY_PREFIX=''
ARG DISTRIB_VERSION=bionic

FROM ${REGISTRY_PREFIX}arm32v7/ubuntu:${DISTRIB_VERSION} as builder

ARG QEMU_VERSION_=v4.1.0-1

COPY docker/qemu-arm-static-$QEMU_VERSION_ /usr/bin/qemu-arm-static

RUN set -x \
  && apt update \
  && apt upgrade -y \
  && apt install --yes --no-install-recommends \
       build-essential \
       cmake \
       ninja-build \
       pkg-config \
       rsync \
       gdb \
       gdbserver \
       lcov 

COPY src /usr/local/src

ARG PARALLELMFLAGS=-j2

ARG DUMB_INIT_VERSION=1.2.2

RUN set -x \
  && builddeps="xxd" \
  && apt install --yes --no-install-recommends $builddeps \
  && builddir="/tmp/out" \
  && mkdir -p "$builddir" \
  && cd "$builddir" \
  && cp -R "/usr/local/src/dumb-init-$DUMB_INIT_VERSION" . \
  && cd "dumb-init-$DUMB_INIT_VERSION" \
  && make "$PARALLELMFLAGS" \
  && chmod +x dumb-init \
  && mv dumb-init /usr/local/bin/dumb-init \
  && dumb-init --version \
  && rm -rf "$builddir" \
  && apt purge -y $builddeps

ARG GTEST_VERSION=1.10.0

RUN set -x \
  && builddir="/tmp/out" \
  && mkdir -p "$builddir" \
  && cd "$builddir" \
  && cmake "/usr/local/src/googletest-release-$GTEST_VERSION" \
  && make "$PARALLELMFLAGS" install \
  && rm -rf "$builddir"

ARG FUSE_VERSION=3.9.1

RUN set -x \
  && builddeps="udev gettext python3 python3-pip python3-setuptools python3-wheel" \
  && apt install --yes --no-install-recommends $builddeps \
  && pip3 install --system meson \
  && builddir="/tmp/out" \
  && mkdir -p "$builddir" \
  && cd "$builddir" \
  && meson "/usr/local/src/libfuse-fuse-$FUSE_VERSION" \
  && meson configure -Dexamples=false \
  && ninja \
  && ninja install \
  && pip3 uninstall -y meson \
  && rm -rf "$builddir" \
  && apt purge -y $builddeps

ARG WEBSOCKETS_VERSION=4.0.10

RUN set -x \
  && apt install --yes --no-install-recommends \
       ca-certificates \
       openssl \
       libssl-dev \
  && builddir="/tmp/out" \
  && mkdir -p "$builddir" \
  && cd "$builddir" \
  && cmake "/usr/local/src/libwebsockets-$WEBSOCKETS_VERSION" \
  && make "$PARALLELMFLAGS" install \
  && rm -rf "$builddir"

ARG JANSSON_VERSION=2.12

RUN set -x \
  && builddir="/tmp/out" \
  && mkdir -p "$builddir" \
  && cd "$builddir" \
  && cmake -DJANSSON_BUILD_DOCS=OFF "/usr/local/src/jansson-$JANSSON_VERSION" \
  && make "$PARALLELMFLAGS" install \
  && rm -rf "$builddir"

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

ARG USERID=1000

RUN set -x \
  && useradd -u "$USERID" -ms /bin/bash user

ENTRYPOINT ["dumb-init", "--"]
CMD [ "/bin/bash" ]

