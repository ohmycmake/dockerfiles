FROM ubuntu:noble

# Update package list and install necessary tools
RUN apt-get update && \
    apt-get install -y sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create cmake user
RUN useradd -m -s /bin/bash cmake && \
    echo "cmake ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to cmake user
USER cmake
WORKDIR /home/cmake

# Default command
CMD ["/bin/bash"]
