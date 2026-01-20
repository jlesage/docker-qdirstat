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

log() {
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
    qt6-qtbase-dev \
    qt6-qt5compat-dev \

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
    qt6-qtbase-dev \
    qt6-qt5compat-dev \

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
patch -d /tmp/qdirstat -p1 < /build/fix_missing_intl_lib.patch

log "Configuring QDirStat..."
sed -i 's/$${CROSS_COMPILE}clang/xx-clang/g' /usr/lib/qt6/mkspecs/common/clang.conf
(
    cd /tmp/qdirstat && \
    /usr/lib/qt6/bin/qmake -spec linux-clang && \
    cd /tmp/qdirstat/src && \
    /usr/lib/qt6/bin/qmake src.pro -spec linux-clang
)
if xx-info is-cross; then
    sed -i "s|/usr/lib/lib|$(xx-info sysroot)usr/lib/lib|g" /tmp/qdirstat/src/Makefile
    sed -i "s|/usr/lib/qt6/mkspecs/|$(xx-info sysroot)usr/lib/qt6/mkspecs/|g" /tmp/qdirstat/src/Makefile
    sed -i "s|/usr/include/|$(xx-info sysroot)usr/include/|g" /tmp/qdirstat/src/Makefile
    sed -i "s|-I/usr/|-I$(xx-info sysroot)usr/|g" /tmp/qdirstat/src/Makefile
    sed -i "s|LFLAGS        = .*|LFLAGS        = $LDFLAGS -L$(xx-info sysroot)usr/lib|" /tmp/qdirstat/src/Makefile
fi

log "Compiling QDirStat..."
make -C /tmp/qdirstat -j$(nproc)

log "Installing QDirStat..."
make INSTALL_ROOT=/tmp/qdirstat-install -C /tmp/qdirstat install
