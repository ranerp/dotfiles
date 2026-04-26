# Function to install Nerd Fonts
install_nerd_fonts() {
    print_info "Installing Nerd Fonts (MesloLGS NF)..."

    # Create fonts directory
    mkdir -p ~/.local/share/fonts

    # Download MesloLGS NF (recommended by Powerlevel10k)
    cd /tmp || exit

    fonts=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )

    for font in "${fonts[@]}"; do
        if [ ! -f ~/.local/share/fonts/"${font//%20/ }" ]; then
            print_info "Downloading ${font//%20/ }..."
            wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/$font" -O ~/.local/share/fonts/"${font//%20/ }"
        else
            print_info "Font ${font//%20/ } already exists"
        fi
    done

    # Update font cache if available
    if command -v fc-cache >/dev/null 2>&1; then
        print_info "Updating font cache..."
        fc-cache -fv > /dev/null 2>&1
    fi

    print_success "Nerd Fonts installed"
    print_info "Note: Configure your terminal to use 'MesloLGS NF' font for best experience"
}

install_extra_fonts() {
    print_info "Installing extra fonts (Monaspace, iA Writer, Fira Code)..."

    OS=$(uname -s)
    case $OS in
        Darwin)
            if command -v brew >/dev/null 2>&1; then
                brew install --cask font-monaspace font-ia-writer-mono font-ia-writer-quattro font-fira-code
                print_success "Extra fonts installed via brew"
            else
                print_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        Linux)
            FONTS_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONTS_DIR"

            # Monaspace
            if ! fc-list | grep -qi "monaspace"; then
                print_info "Downloading Monaspace fonts..."
                MONASPACE_VERSION=$(curl -s https://api.github.com/repos/githubnext/monaspace/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
                if [ -n "$MONASPACE_VERSION" ]; then
                    wget -q "https://github.com/githubnext/monaspace/releases/download/${MONASPACE_VERSION}/monaspace-${MONASPACE_VERSION}.zip" -O /tmp/monaspace.zip
                    unzip -q /tmp/monaspace.zip -d /tmp/monaspace
                    find /tmp/monaspace -name "*.otf" -exec cp {} "$FONTS_DIR/" \;
                    rm -rf /tmp/monaspace /tmp/monaspace.zip
                    print_success "Monaspace fonts installed"
                else
                    print_error "Failed to get Monaspace version"
                fi
            else
                print_info "Monaspace already installed"
            fi

            # iA Writer Mono
            if ! fc-list | grep -qi "iA Writer Mono"; then
                print_info "Downloading iA Writer Mono fonts..."
                IA_BASE="https://github.com/iaolo/iA-Fonts/raw/master/iA%20Writer%20Mono/Fonts/Static"
                for variant in "Regular" "Bold" "Italic" "BoldItalic"; do
                    wget -q "${IA_BASE}/iAWriterMonoS-${variant}.ttf" -O "$FONTS_DIR/iAWriterMonoS-${variant}.ttf"
                done
                print_success "iA Writer Mono fonts installed"
            else
                print_info "iA Writer Mono already installed"
            fi

            # iA Writer Quattro
            if ! fc-list | grep -qi "iA Writer Quattro"; then
                print_info "Downloading iA Writer Quattro fonts..."
                IA_BASE="https://github.com/iaolo/iA-Fonts/raw/master/iA%20Writer%20Quattro/Fonts/Static"
                for variant in "Regular" "Bold" "Italic" "BoldItalic"; do
                    wget -q "${IA_BASE}/iAWriterQuattroS-${variant}.ttf" -O "$FONTS_DIR/iAWriterQuattroS-${variant}.ttf"
                done
                print_success "iA Writer Quattro fonts installed"
            else
                print_info "iA Writer Quattro already installed"
            fi

            # Fira Code
            if ! fc-list | grep -qi "Fira Code"; then
                print_info "Installing Fira Code via package manager..."
                if command -v apt-get >/dev/null 2>&1; then
                    sudo apt-get install -y fonts-firacode
                else
                    print_error "apt-get not found — install Fira Code manually"
                fi
            else
                print_info "Fira Code already installed"
            fi

            if command -v fc-cache >/dev/null 2>&1; then
                print_info "Updating font cache..."
                fc-cache -fv > /dev/null 2>&1
            fi
            ;;
        *)
            print_error "Unsupported OS: $OS"
            return 1
            ;;
    esac
}
