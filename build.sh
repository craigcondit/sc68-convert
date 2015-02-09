#!/bin/bash
set -e

VERSION=nocrew-r593

BASEDIR="$(dirname "$0")"
cd "${BASEDIR}"
BASEDIR="$(pwd)"
echo $BASEDIR
mkdir -p tmp
cd tmp

# clean
if [ -d "sc68-${VERSION}" ]; then
  rm -rf "sc68-${VERSION}"
fi

# unpack source
tar -zxvf "${BASEDIR}"/sc68-${VERSION}.tar.gz
cd sc68-${VERSION}

# apply patches
for p in "${BASEDIR}/patches/"*.patch ; do 
  patch -p1 < "${p}"
done

./configure --prefix=/usr/local
make -j16
echo "About to install. Enter your password if prompted."
sudo make -j16 install
