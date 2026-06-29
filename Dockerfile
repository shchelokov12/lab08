FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Добавили libgtk-3-dev и pkg-config
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    cmake \
    libgtest-dev \
    libgtk-3-dev \
    pkg-config \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tp-labs/lab07 print
WORKDIR print

RUN cmake -H. -B_build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install \
    && cmake --build _build \
    && cmake --build _build --target install

ENV LOG_PATH /home/logs/log.txt
VOLUME /home/logs

WORKDIR _install/bin
ENTRYPOINT ["./demo"]
