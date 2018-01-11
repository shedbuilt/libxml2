#!/bin/bash
# Apply the BLFS patch to prevent segfaults when the module is built with Python 3.6.4
patch -Np1 -i "${SHED_PATCHDIR}/libxml2-2.9.7-python3_hack-1.patch"
# Fix another Python 3.6.4 / GCC 7 issue
sed -i '/_PyVerify_fd/,+1d' python/types.c
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 || return 1
make -j $SHED_NUMJOBS || return 1
make DESTDIR="$SHED_FAKEROOT" install || return 1
