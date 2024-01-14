#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

function log {
    echo ">>> $*"
}

QDIRSTAT_URL="$1"

if [ -z "$QDIRSTAT_URL" ]; then
    log "ERROR: QDirStat URL missing."
    exit 1
fi

#
# Install required packages.
#
apk --no-cache add \
    curl \
    clang \
    make \
    patch \
    qtchooser \
    qt5-qtbase-dev \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
    qt5-qtbase-dev \

#
# Download sources.
#

log "Downloading QDirStat package..."
mkdir /tmp/qdirstat
curl -# -L -f ${QDIRSTAT_URL} | tar xz --strip 1 -C /tmp/qdirstat

#
# Compile QDirStat.
#

log "Patching QDirStat..."
patch -d /tmp/qdirstat -p1 < /build/log_path.patch
patch -d /tmp/qdirstat -p1 < /build/use_default_shell.patch
patch -d /tmp/qdirstat -p1 < /build/disable_trash.patch
patch -d /tmp/qdirstat -p1 < /build/disable_file_manager.patch
patch -d /tmp/qdirstat -p1 < /build/fix_allperms.patch
patch -d /tmp/qdirstat -p1 < /build/fix_systemfilechecker_include.patch

log "Configuring QDirStat..."
sed -i 's/$${CROSS_COMPILE}clang/xx-clang/g' /usr/lib/qt5/mkspecs/common/clang.conf
(
    cd /tmp/qdirstat && \
    qmake -spec linux-clang && \
    cd /tmp/qdirstat/src && \
    qmake src.pro -spec linux-clang
)
sed -i "s| /usr/lib/libQt5| $(xx-info sysroot)usr/lib/libQt5|g" /tmp/qdirstat/src/Makefile
sed -i "s|LFLAGS        = .*|LFLAGS        = $LDFLAGS|" /tmp/qdirstat/src/Makefile

log "Compiling QDirStat..."
make -C /tmp/qdirstat -j$(nproc)

log "Installing QDirStat..."
make INSTALL_ROOT=/tmp/qdirstat-install -C /tmp/qdirstat install
