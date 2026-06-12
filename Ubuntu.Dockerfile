FROM ubuntu:26.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for any eventuall compilation or debug
RUN apt-get update && apt-get install -y \
	gcc \
	g++ \
	rsync \
	ccache \
	git \
	make \
	ninja-build \
	clang \
	pkg-config \
	zlib1g \
	bzip2 \
	gzip \
	libtool \
	autoconf \
	unzip \
	wget \
	distcc \
	&& apt-get clean


# Stuff for the sound, framework (OpenGL, Vulkan, directx, metal, etc.), etc
RUN apt-get install -y \
		libpng-dev \
		libbz2-dev \
		libharfbuzz-dev \
		libbrotli-dev \
		mesa-utils \
		libglu1-mesa-dev \
		mesa-common-dev \
		libasound2-dev \
		libxext-dev

#RUN useradd distcc


# Force gcc to link arch based requests using the default g++
RUN  \
	ln -s /usr/bin/gcc /usr/bin/x86_64-pc-linux-gnu-gcc && \
	ln -s /usr/bin/g++ /usr/bin/x86_64-pc-linux-gnu-g++ && \
	ln -s /usr/bin/gcc-$(gcc -dumpversion) /usr/bin/x86_64-pc-linux-gnu-gcc-$(gcc -dumpversion) && \
	ln -s /usr/bin/g++-$(gcc -dumpversion) /usr/bin/x86_64-pc-linux-gnu-g++-$(gcc -dumpversion) 

# See MASQUERADING in https://www.distcc.org/man/distcc_1.html
RUN cd /usr/lib/distcc/ && ln -s ../../bin/distcc c++
RUN cd /usr/lib/ccache/ && ln -s ../../bin/ccache c++

RUN mkdir -p /usr/lib/distcc/bin && cd /usr/lib/distcc/bin && \
	ln -s ../../../bin/distcc /usr/lib/distcc/x86_64-pc-linux-gnu-gcc && \
	ln -s ../../../bin/distcc /usr/lib/distcc/x86_64-pc-linux-gnu-g++ && \
	ln -s ../../../bin/distcc /usr/lib/distcc/x86_64-pc-linux-gnu-gcc-$(gcc -dumpversion) && \
	ln -s ../../../bin/distcc /usr/lib/distcc/x86_64-pc-linux-gnu-g++-$(gcc -dumpversion) 

RUN \
	ln -s /usr/bin/ccache /usr/lib/ccache/x86_64-pc-linux-gnu-gcc && \
	ln -s /usr/bin/ccache /usr/lib/ccache/x86_64-pc-linux-gnu-g++ && \
	ln -s /usr/bin/ccache /usr/lib/ccache/x86_64-pc-linux-gnu-gcc-$(gcc -dumpversion) && \
	ln -s /usr/bin/ccache /usr/lib/ccache/x86_64-pc-linux-gnu-g++-$(gcc -dumpversion)

# https://wilsonhongblog.wordpress.com/2016/05/24/using-ccache-on-distcc-server/
RUN useradd distcc
RUN mkdir -p /cache
RUN chown distcc: /cache
RUN find /usr/lib/ccache/ -type l > /etc/distcc/DISTCC_CMDLIST
ENV DISTCC_CMDLIST /etc/distcc/DISTCC_CMDLIST 
ENV CCACHE_DIR /cache
ENV PATH /usr/lib/ccache:$PATH


# Early path, read MASQUERADING at https://www.distcc.org/man/distcc_1.html
# this is to avoid the recursive problem (111)
ENV PATH=/usr/lib/distcc/bin:$PATH

# https://askubuntu.com/questions/692223/apt-method-bzip2-doesnt-exist
RUN ln -s /usr/lib/apt/methods/gzip /usr/lib/apt/methods/bzip2
RUN rm -rf /var/lib/apt/lists/*

USER distcc
EXPOSE 3632

# Default command
CMD ["/bin/bash"]
