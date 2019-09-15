# Docker container for QDirStat
[![Docker Image](https://images.microbadger.com/badges/image/jlesage/qdirstat.svg)](http://microbadger.com/#/images/jlesage/qdirstat) [![Build Status](https://travis-ci.org/jlesage/docker-qdirstat.svg?branch=master)](https://travis-ci.org/jlesage/docker-qdirstat) [![GitHub Release](https://img.shields.io/github/release/jlesage/docker-qdirstat.svg)](https://github.com/jlesage/docker-qdirstat/releases/latest) [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/JocelynLeSage/0usd)

This is a Docker container for [QDirStat](https://github.com/shundhammer/qdirstat).

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

[![QDirStat logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/qdirstat-icon.png&w=200)](https://github.com/shundhammer/qdirstat)[![QDirStat](https://dummyimage.com/400x110/ffffff/575757&text=QDirStat)](https://github.com/shundhammer/qdirstat)

QDirStat is a graphical application to show where your disk space has gone and to help you to clean it up.

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the QDirStat docker container with the following command:
```
docker run -d \
    --name=qdirstat \
    -p 5800:5800 \
    -v /docker/appdata/qdirstat:/config:rw \
    -v $HOME:/storage:ro \
    jlesage/qdirstat
```

Where:
  - `/docker/appdata/qdirstat`: This is where the application stores its configuration, log and any files needing persistency.
  - `$HOME`: This location contains files from your host that need to be accessible by the application.

Browse to `http://your-host-ip:5800` to access the QDirStat GUI.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-qdirstat.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

For other great Dockerized applications, see https://jlesage.github.io/docker-apps.

[create a new issue]: https://github.com/jlesage/docker-qdirstat/issues
