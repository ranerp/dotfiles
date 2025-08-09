# Install k9s if kubectl is available
install_k9s() {
    if command -v kubectl >/dev/null 2>&1; then
        print_info "Installing k9s (Kubernetes TUI)..."

        # Detect architecture
        ARCH=$(uname -m)
        case $ARCH in
            x86_64) K9S_ARCH="amd64" ;;
            aarch64|arm64) K9S_ARCH="arm64" ;;
            *) K9S_ARCH="amd64" ;;
        esac

        # Get latest k9s release
        K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

        if [ -n "$K9S_VERSION" ]; then
            cd /tmp
            wget -q "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz"
            tar -xzf "k9s_Linux_${K9S_ARCH}.tar.gz"
            sudo mv k9s /usr/local/bin/
            rm -f "k9s_Linux_${K9S_ARCH}.tar.gz"
            print_success "k9s installed (${K9S_VERSION})"
        else
            print_error "Failed to get k9s version"
        fi
    else
        print_info "Skipping k9s installation (kubectl not available)"
    fi
}
