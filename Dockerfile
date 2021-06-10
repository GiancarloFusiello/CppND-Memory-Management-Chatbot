FROM selenium/standalone-chrome-debug:3.141.59-zirconium as dev

USER root

ARG DEV_DEPENDENCIES="git ca-certificates gdb net-tools wget"
ARG BUILD_DEPENDENCIES="build-essential"
ARG THIRD_PARTY_DEPENDENCIES="libwxgtk3.0-dev libwxgtk3.0-0v5"

WORKDIR /srv/app

COPY docker-start-script.sh .

RUN set -ex \
    && apt-get update -y \
    # install system dependencies
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ${DEV_DEPENDENCIES} \
        ${BUILD_DEPENDENCIES} \
        ${THIRD_PARTY_DEPENDENCIES} \
    # install cmake
    && wget https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3-Linux-x86_64.tar.gz -P /tmp \
    && wget https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3-Linux-x86_64.sh -P /tmp \
    && chmod +x /tmp/cmake-3.20.3-Linux-x86_64.sh \
    && /bin/sh /tmp/cmake-3.20.3-Linux-x86_64.sh --prefix=/usr/local --skip-license \
    # clean up
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf ~/.cache/* /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

# VNC server
EXPOSE 5900

CMD bash -c "./docker-start-script.sh && sleep infinity"



FROM dev as run_app

WORKDIR /srv/app/build

COPY . ..

RUN cmake .. && make

CMD bash -c "../docker-start-script.sh && sleep 2 && ./membot"
