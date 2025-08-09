# Install eza (modern ls replacement)
install_eza() {
    print_info "Installing eza (modern ls replacement)..."

    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) EZA_ARCH="x86_64" ;;
        aarch64|arm64) EZA_ARCH="aarch64" ;;
        *) EZA_ARCH="x86_64" ;;
    esac

    # Get latest eza release
    EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -n "$EZA_VERSION" ]; then
        cd /tmp
        wget -q "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        tar -xzf "eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        sudo mv eza /usr/local/bin/
        rm -f "eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        print_success "eza installed (${EZA_VERSION})"
    else
        print_error "Failed to get eza version"
    fi
}

# Setup EZA themes
setup_eza_themes() {
    print_info "Setting up eza themes..."

    THEMES_DIR="$HOME/.oh-my-zsh/custom/eza-themes"

    if [ ! -d "$THEMES_DIR" ]; then
        print_info "Cloning eza themes repository..."
        git clone https://github.com/eza-community/eza-themes.git "$THEMES_DIR"
        print_success "eza themes cloned"
    else
        print_info "eza themes already exist"
    fi

    mkdir -p ~/.config/eza

    # Use onedark theme if available, fallback to default
    if [ -f "$THEMES_DIR/themes/one_dark.yml" ]; then
        ln -sf "$THEMES_DIR/themes/one_dark.yml" ~/.config/eza/theme.yml
        print_success "eza onedark theme configured"
    elif [ -f "$THEMES_DIR/themes/default.yml" ]; then
        ln -sf "$THEMES_DIR/themes/default.yml" ~/.config/eza/theme.yml
        print_success "eza default theme configured"
    else
        print_error "eza themes not found"
    fi
}