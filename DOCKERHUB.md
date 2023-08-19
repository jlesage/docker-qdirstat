# Docker container for QDirStat
[![Release](https://img.shields.io/github/release/jlesage/docker-qdirstat.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-qdirstat/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/qdirstat/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/qdirstat/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/qdirstat?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/qdirstat)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/qdirstat?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/qdirstat)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-qdirstat/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-qdirstat/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-qdirstat)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [QDirStat](https://github.com/shundhammer/qdirstat).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![QDirStat logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/qdirstat-icon.png&w=110)](https://github.com/shundhammer/qdirstat)[![QDirStat](https://images.placeholders.dev/?width=256&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=QDirStat&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://github.com/shundhammer/qdirstat)

QDirStat is a graphical application to show where your disk space has gone and
to help you to clean it up.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is given as an example
    and parameters should be adjusted to your need.

Launch the QDirStat docker container with the following command:
```shell
docker run -d \
    --name=qdirstat \
    -p 5800:5800 \
    -v /docker/appdata/qdirstat:/config:rw \
    -v /home/user:/storage:ro \
    jlesage/qdirstat
```

Where:

  - `/docker/appdata/qdirstat`: This is where the application stores its configuration, states, log and any files needing persistency.
  - `/home/user`: This location contains files from your host that need to be accessible to the application.

Browse to `http://your-host-ip:5800` to access the QDirStat GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-qdirstat.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-qdirstat/issues
