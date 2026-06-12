# compile-farm-config
C++ compile farm confoiguration using docker

> See: [This Blog](https://oneuptime.com/blog/post/2026-03-02-how-to-configure-distcc-for-distributed-compilation-on-ubuntu/view) for how to use a client

Method 1: Using the Masquerade Symlinks

distcc installs wrappers in /usr/lib/distcc/:

# Add to PATH (before /usr/bin)
export PATH="/usr/lib/distcc:$PATH"

# Now gcc/g++ calls go through distcc
which gcc
# /usr/lib/distcc/gcc

--- 
Because of the difficult to setup, especially for more specialized libraries such as SDL, I decided to give up on this. But should work for simpler projects
