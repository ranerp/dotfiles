# Install FZF Shell Integration (System package manager may have older version and trickier to get working)
install_fzf_shell_integration() {
    print_info "Installing fzf with shell integration..."

    if [ ! -d "$HOME/.fzf" ]; then
        # Clone fzf repository
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

        # Install fzf with shell integration
        ~/.fzf/install --key-bindings --completion --no-update-rc

        print_success "fzf installed with shell integration"
    else
        print_info "fzf already installed"
    fi
}