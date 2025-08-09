# Development container with dotfiles  
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages first
RUN apt-get update && apt-get install -y \
    sudo \
    zsh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install additional packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        curl \
        wget \
        git \
        build-essential \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        unzip \
        tar \
        jq \
        tree \
        htop \
        neofetch \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Docker CLI (for development)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Install Node.js (for development)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Python and pip
RUN apt-get update && apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

# Get uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set up the workspace
RUN mkdir -p /workspaces/project
WORKDIR /workspaces/project

# Set zsh as default shell
SHELL ["/bin/zsh", "-c"]

# Set default command
CMD ["/bin/zsh"]