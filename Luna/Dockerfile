# Use the official image as a parent image
FROM ubuntu:22.04
USER root

RUN groupadd -g 1000 user
RUN useradd -r -u 1000 -g 1000 -d /home/user user
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    clang \
    cmake \
    curl \
    dfu-util \
    flex \
    gawk \
    gcc-arm-none-eabi \
    git \
    jq \
    libboost-all-dev \
    libeigen3-dev \
    libreadline-dev \
    openocd \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    tcl \
    tcl-dev \
    zlib1g-dev \
    mc \
    libgl1-mesa-glx \
    libnss3 \
    libxcomposite-dev \
    libxdamage-dev \
    libxrandr-dev \
    libxtst-dev \
    libxkbcommon-x11-0 \
    dbus \
    libasound2 \
    iproute2 \
    vim \
    libhidapi-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
COPY --chmod=0755 prepare.sh /
RUN cd / && ./prepare.sh
ENV LUNA_PLATFORM="luna_boards.tangprimer20k:TangPrimer20kPlatform"
ENV PATH="$PATH:/gowin/bin"

ENTRYPOINT [\
            "/bin/bash",\
            "-c",\
            "ip link add link eth0 address D8:9E:F3:38:25:C5 eth0.1 type macvlan && \
            exec bash"]



