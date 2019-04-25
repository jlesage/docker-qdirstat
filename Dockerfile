#
# qdirstat Dockerfile
#
# https://github.com/jlesage/docker-qdirstat
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.9-v3.5.2

# Define software versions.
ARG QDIRSTAT_VERSION=1.4

# Define software download URLs.
ARG QDIRSTAT_URL=https://github.com/shundhammer/qdirstat/archive/${QDIRSTAT_VERSION}.tar.gz

# Define working directory.
WORKDIR /tmp

# Install QDirStat.
RUN \
    # Install packages needed by the build.
    add-pkg --virtual build-dependencies \
        curl \
        build-base \
        patch \
        qt5-qtbase-dev \
        gdb \
        && \

    # Download the QDirStat package.
    echo "Downloading QDirStat package..." && \
    curl -# -L ${QDIRSTAT_URL} | tar xz && \

    # Download patches.
    echo "Downloading patches..." && \
    wget https://raw.githubusercontent.com/jlesage/docker-qdirstat/master/log_path.patch && \
    wget https://raw.githubusercontent.com/jlesage/docker-qdirstat/master/use_default_shell.patch && \
    wget https://raw.githubusercontent.com/jlesage/docker-qdirstat/master/disable_trash.patch && \
    wget https://raw.githubusercontent.com/jlesage/docker-qdirstat/master/disable_file_manager.patch && \

    # Compile QDirStat.
    cd qdirstat-${QDIRSTAT_VERSION} && \
    patch -p1 < ../log_path.patch && \
    patch -p1 < ../use_default_shell.patch && \
    patch -p1 < ../disable_trash.patch && \
    patch -p1 < ../disable_file_manager.patch && \
    /usr/lib/qt5/bin/qmake && \
    make -j$(nproc) && \
    cp -v src/qdirstat /usr/bin/ && \
    strip /usr/bin/qdirstat && \
    cd .. && \

    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Install dependencies.
RUN add-pkg \
        qt5-qtbase-x11 \
        mesa-dri-swrast \
        # Tools used by the app
        git \
        make \
        xterm

# Adjust the openbox config.
RUN \
    # Maximize only the main/initial window.
    sed-patch 's/<application type="normal">/<application type="normal" title="QDirStat">/' \
        /etc/xdg/openbox/rc.xml && \
    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="QDirStat">/a \    <layer>below</layer>' \
        /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/qdirstat-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV APP_NAME="QDirStat"

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="qdirstat" \
      org.label-schema.description="Docker container for QDirStat" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-qdirstat" \
      org.label-schema.schema-version="1.0"
