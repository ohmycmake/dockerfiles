FROM ubuntu:noble

# Update package list and install necessary tools
RUN apt-get update && \
    apt-get install -y \
    # Basic system utilities
    sudo \
    curl \
    wget \
    git \
    unzip \
    zip \
    ca-certificates \
    gnupg \
    lsb-release \
    # Build essentials
    build-essential \
    gcc \
    g++ \
    clang \
    gdb \
    make \
    ninja-build \
    # CMake dependencies
    ccache \
    # Additional development tools
    pkg-config \
    elfutils \
    autoconf \
    automake \
    libtool \
    # Python for CMake scripting
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    # Text editors
    vim \
    # Other useful utilities
    htop \
    tree \
    less \
    file \
    bash-completion \
    strace && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install CMake from Kitware official repository
RUN wget -O /tmp/kitware-archive.sh https://apt.kitware.com/kitware-archive.sh && \
    bash /tmp/kitware-archive.sh && \
    rm /tmp/kitware-archive.sh && \
    apt-get update && \
    apt-get install -y cmake cmake-curses-gui && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Neovim from GitHub releases
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    rm -rf /opt/nvim-linux-x86_64 && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz && \
    ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Create cmake user
RUN useradd -m -s /bin/bash cmake && \
    echo "cmake ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to cmake user
USER cmake
WORKDIR /home/cmake

# Default command
CMD ["/bin/bash"]
