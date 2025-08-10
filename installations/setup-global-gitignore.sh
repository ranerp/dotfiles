# Setup global gitignore
setup_global_gitignore() {
    print_info "Setting up global gitignore..."
    cp "$DOTFILES_DIR"/.gitignore_global ~/

    # Configure git to use it
    git config --global core.excludesfile ~/.gitignore_global
    print_success "Global gitignore configured"
}
