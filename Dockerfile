FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    live-build \
    cpio xorriso squashfs-tools syslinux isolinux dosfstools \
    ca-certificates curl wget git make sudo \
    && rm -rf /var/lib/apt/lists/*

# live-build requires privileged operations; container should be run --privileged
WORKDIR /workspace
