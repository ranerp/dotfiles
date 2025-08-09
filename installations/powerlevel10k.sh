# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    print_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    print_success "Powerlevel10k theme installed"
else
    print_info "Powerlevel10k theme already installed"
fi