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
RUN cd /usr/lib/distcc/bin && \
	ln -s ../../../bin/distcc x86_64-linux-gnu-c++ && \
	ln -s ../../../bin/distcc x86_64-linux-gnu-g++ && \
	ln -s ../../../bin/distcc x86_64-linux-gnu-gcc 

RUN cd /usr/lib/distcc && \
	ln -s ../../bin/distcc x86_64-linux-gnu-c++ && \
	ln -s ../../bin/distcc x86_64-linux-gnu-g++ && \
	ln -s ../../bin/distcc x86_64-linux-gnu-gcc 

# ccache only, still under lib/ccache
RUN \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-gcc && \
	ln -s /usr/bin/ccache /usr/lib/ccache/bin/x86_64-linux-gnu-g++ 


# Distcc user already exists in the arch ver

RUN mkdir -p /cache && chown distcc: /cache

# DistCC command whitelist
RUN find /usr/lib/distcc -type l > /etc/distcc/DISTCC_CMDLIST

ENV DISTCC_CMDLIST=/etc/distcc/DISTCC_CMDLIST
ENV CCACHE_DIR=/cache

# Early path, read MASQUERADING at https://www.distcc.org/man/distcc_1.html
# this is to avoid the recursive problem (111)
ENV PATH=/usr/lib/distcc/bin:$PATH

ENV PATH=/usr/lib/ccache/bin:$PATH

USER distcc

EXPOSE 3632

CMD ["/bin/bash"]

