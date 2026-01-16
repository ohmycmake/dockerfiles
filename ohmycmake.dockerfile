FROM ubuntu:noble

ENV TERM=xterm-256color

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

# Install Neovim from GitHub releases (auto-detect architecture)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then NVIM_ARCH="arm64"; else NVIM_ARCH="x86_64"; fi && \
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz && \
    rm -rf /opt/nvim-linux-${NVIM_ARCH} && \
    tar -C /opt -xzf nvim-linux-${NVIM_ARCH}.tar.gz && \
    rm nvim-linux-${NVIM_ARCH}.tar.gz && \
    ln -sf /opt/nvim-linux-${NVIM_ARCH}/bin/nvim /usr/local/bin/nvim

# Install Node.js (for nvim plugins like LSP, Mason, etc.)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install ripgrep and fd-find (for telescope and other nvim plugins)
RUN apt-get update && \
    apt-get install -y ripgrep fd-find && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create cmake user
RUN useradd -m -s /bin/bash cmake && \
    echo "cmake ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to cmake user
USER cmake
WORKDIR /home/cmake

# Clone dotfiles and setup nvim config
RUN git clone https://github.com/ohmycmake/dotfiles.git /tmp/dotfiles && \
    mkdir -p ~/.config && \
    cp -r /tmp/dotfiles/nvim ~/.config/nvim && \
    rm -rf /tmp/dotfiles

# Pre-install nvim plugins (lazy.nvim will bootstrap on first run)
RUN nvim --headless "+Lazy! sync" +qa || true

# Default command
CMD ["/bin/bash"]
