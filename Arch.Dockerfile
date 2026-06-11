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

# DistCC masquerade support
RUN mkdir -p /usr/lib/distcc

# Support for non arch distros
RUN GVER=$(gcc -dumpversion | cut -d. -f1) && \
	ln -s ../../bin/distcc /usr/lib/distcc/x86_64-linux-gnu-gcc && \
	ln -s ../../bin/distcc /usr/lib/distcc/x86_64-linux-gnu-g++ && \
	ln -s ../../bin/distcc /usr/lib/distcc/x86_64-linux-gnu-gcc-$GVER && \
	ln -s ../../bin/distcc /usr/lib/distcc/x86_64-linux-gnu-g++-$GVER && \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-gcc && \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-g++ && \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-gcc-$GVER && \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-g++-$GVER


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
