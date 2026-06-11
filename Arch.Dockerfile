FROM archlinux:latest

# Update system and install development tools
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        gcc \
        clang \
        cmake \
        ninja \
        make \
        git \
        rsync \
        ccache \
        distcc \
        pkgconf \
        zlib \
        bzip2 \
        gzip \
        libtool \
        autoconf \
        unzip \
        wget \
        harfbuzz \
        brotli \
        libpng \
        mesa-utils \
        glu \
        alsa-lib \
        libxext && \
    pacman -Scc --noconfirm

RUN cd /usr/lib/ccache/ && ln -s ../../bin/ccache c++

# Distcc user already exists in the arch ver
RUN mkdir -p /cache && chown distcc:distcc /cache

# DistCC command whitelist
RUN find /usr/lib/distcc -type l > /etc/distcc/DISTCC_CMDLIST

ENV DISTCC_CMDLIST=/etc/distcc/DISTCC_CMDLIST
ENV CCACHE_DIR=/cache
ENV PATH=/usr/lib/ccache/bin:$PATH

USER distcc

EXPOSE 3632

CMD ["/bin/bash"]
