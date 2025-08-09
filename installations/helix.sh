# Install Helix editor
install_helix() {
    print_info "Installing Helix editor..."

    # Detect OS and architecture
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    case $OS in
        darwin) HELIX_OS="macos" ;;
        linux) HELIX_OS="linux" ;;
        *) print_error "Unsupported OS: $OS"; return ;;
    esac

    case $ARCH in
        x86_64) HELIX_ARCH="x86_64" ;;
        aarch64|arm64) HELIX_ARCH="aarch64" ;;
        *) HELIX_ARCH="x86_64" ;;
    esac

    # Get latest Helix release
    HELIX_VERSION=$(curl -s https://api.github.com/repos/helix-editor/helix/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -n "$HELIX_VERSION" ]; then
        cd /tmp

        if [ "$HELIX_OS" = "macos" ]; then
            wget -q "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
            tar -xf "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
            sudo mv "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}" /usr/local/helix
            sudo ln -sf /usr/local/helix/hx /usr/local/bin/hx
            rm -f "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
        else
            wget -q "https://github.com/helix-editor/helix/releases/download/${HELIX_VERSION}/helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
            tar -xf "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
            sudo mv "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}" /usr/local/helix
            sudo ln -sf /usr/local/helix/hx /usr/local/bin/hx
            rm -f "helix-${HELIX_VERSION}-${HELIX_ARCH}-${HELIX_OS}.tar.xz"
        fi

        print_success "Helix editor installed (${HELIX_VERSION})"
        print_info "Run 'hx --health' to check language server support"
    else
        print_error "Failed to get Helix version"
    fi
}

# Setup Helix configuration
setup_helix_config() {
    print_info "Setting up Helix configuration..."

    # Create Helix config directory
    mkdir -p ~/.config/helix

    # Create symlink to config file
    if [ -f "$DOTFILES_DIR/config.toml" ]; then
        create_symlink "$DOTFILES_DIR/helix-config.toml" "$HOME/.config/helix/config.toml"
        print_success "Helix configuration linked"
    else
        print_error "Helix config file not found in dotfiles"
    fi
}