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