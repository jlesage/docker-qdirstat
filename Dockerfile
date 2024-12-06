#
# qdirstat Dockerfile
#
# https://github.com/jlesage/docker-qdirstat
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG QDIRSTAT_VERSION=1.9

# Define software download URLs.
ARG QDIRSTAT_URL=https://github.com/shundhammer/qdirstat/archive/${QDIRSTAT_VERSION}.tar.gz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Build QDirStat.
FROM --platform=$BUILDPLATFORM alpine:3.16 AS qdirstat
ARG TARGETPLATFORM
ARG QDIRSTAT_URL
COPY --from=xx / /
COPY src/qdirstat /build
RUN /build/build.sh "$QDIRSTAT_URL"
RUN xx-verify /tmp/qdirstat-install/usr/bin/qdirstat

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.6.7

ARG QDIRSTAT_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN add-pkg \
        qt5-qtbase-x11 \
        adwaita-qt \
        mesa-gl \
        # A font is needed.
        font-croscore \
        # Tools used by the app
        git \
        make \
        xterm

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/qdirstat-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=qdirstat /tmp/qdirstat-install/usr/bin/qdirstat /usr/bin/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "QDirStat" && \
    set-cont-env APP_VERSION "$QDIRSTAT_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Define mountable directories.
VOLUME ["/storage"]

# Metadata.
LABEL \
      org.label-schema.name="qdirstat" \
      org.label-schema.description="Docker container for QDirStat" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-qdirstat" \
      org.label-schema.schema-version="1.0"
