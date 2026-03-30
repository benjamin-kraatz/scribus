FROM ubuntu:24.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install basic tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    ca-certificates \
    curl \
    wget \
    pkg-config \
    gdb \
    lldb \
    && rm -rf /var/lib/apt/lists/*

# Install Qt6 development libraries
RUN apt-get update && apt-get install -y \
    qt6-base-dev \
    qt6-base-private-dev \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    libqt6core5compat6-dev \
    libqt6svg6-dev \
    linguist-qt6 \
    && rm -rf /var/lib/apt/lists/*

# Install core Scribus build dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libcairo2-dev \
    libharfbuzz-dev \
    libharfbuzz-icu0 \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libxml2-dev \
    liblcms2-dev \
    libpoppler-cpp-dev \
    libpoppler-dev \
    libpoppler-private-dev \
    && rm -rf /var/lib/apt/lists/*

# Install optional but recommended dependencies
RUN apt-get update && apt-get install -y \
    libcups2-dev \
    fontconfig \
    libfontconfig1-dev \
    ghostscript \
    python3 \
    python3-dev \
    python3-pip \
    hunspell \
    libhunspell-dev \
    libboost-all-dev \
    libpodofo-dev \
    graphicsmagick \
    graphicsmagick++-dev \
    librevenge-dev \
    libfreehand-dev \
    libcdr-dev \
    libpagemaker-dev \
    libmspub-dev \
    libqxp-dev \
    libvisio-dev \
    libzmf-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional development tools
RUN apt-get update && apt-get install -y \
    ninja-build \
    ccache \
    clang-format \
    cppcheck \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
