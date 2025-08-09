# Install bat (better cat)
install_bat() {
    print_info "Installing bat (better cat)..."

    # Detect OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    case $OS in
        darwin)
            # macOS - use Homebrew if available, otherwise GitHub release
            if command -v brew >/dev/null 2>&1; then
                brew install bat
                print_success "bat installed via Homebrew"
            else
                print_info "Homebrew not found, installing from Github releases..."
                install_bat_from_github "macos"
            fi
            ;;
        linux)
            # Try package manager first, fallback to GitHub
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y bat
                print_success "bat installed via apt"
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y bat
                print_success "bat installed via yum"
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y bat
                print_success "bat installed via dnf"
            else
                print_info "Package manager not found, installing from GitHub releases..."
                install_bat_from_github "linux"
            fi
            ;;
        *)
            print_error "Unsupported OS: $OS"
            return
            ;;
    esac
}

# Install bat from GitHub releases
install_bat_from_github() {
    local os_type="$1"

    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) BAT_ARCH="x86_64" ;;
        aarch64|arm64) BAT_ARCH="aarch64" ;;
        *) BAT_ARCH="x86_64" ;;
    esac

    # Get latest bat release
    BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')

    if [ -n "$BAT_VERSION" ]; then
        cd /tmp || exit

        if [ "$os_type" = "macos" ]; then
            wget -q "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${BAT_ARCH}-apple-darwin.tar.gz"
            tar -xzf "bat-v${BAT_VERSION}-${BAT_ARCH}-apple-darwin.tar.gz"
            sudo mv "bat-v${BAT_VERSION}-${BAT_ARCH}-apple-darwin/bat" /usr/local/bin/
            rm -rf "bat-v${BAT_VERSION}-${BAT_ARCH}-apple-darwin"*
        else
            wget -q "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${BAT_ARCH}-unknown-linux-gnu.tar.gz"
            tar -xzf "bat-v${BAT_VERSION}-${BAT_ARCH}-unknown-linux-gnu.tar.gz"
            sudo mv "bat-v${BAT_VERSION}-${BAT_ARCH}-unknown-linux-gnu/bat" /usr/local/bin/
            rm -rf "bat-v${BAT_VERSION}-${BAT_ARCH}-unknown-linux-gnu"*
        fi

        print_success "bat installed from GitHub (v${BAT_VERSION})"
    else
        print_error "Failed to get bat version"
    fi
}