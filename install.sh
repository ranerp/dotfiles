#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Get the directory where this script is located
DOTFILES_DIR="$PWD"
if [ ! -f "$DOTFILES_DIR/install.sh" ]; then
  print_error "Please run this script from the dotfiles directory"
  exit 1
fi

print_info "Installing dotfiles from $DOTFILES_DIR"

# Create symlinks for dotfiles
files=(".zshrc" ".p10k.zsh" ".gitconfig" ".aliases" ".functions" ".exports" ".tmux.conf" ".vimrc")

for file in "${files[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# Install Nerd Fonts
install_nerd_fonts

# Install k9s
install_k9s

# Install fzf shell integration
install_fzf_shell_integration

# Install eza
install_eza

# Setup eza themes
setup_eza_themes

# Install bat
install_bat

# Install Helix editor
install_helix

# Setup Helix config
setup_helix_config

# Setup global gitignore
setup_global_gitignore

# Install plugins
plugins=(
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "fzf-zsh-plugin https://github.com/unixorn/fzf-zsh-plugin.git"
    "fzf-tab https://github.com/Aloxaf/fzf-tab"
    "zsh-bat https://github.com/fdellwing/zsh-bat.git"
)

for plugin in "${plugins[@]}"; do
    plugin_name="${plugin%% *}"
    plugin_url="${plugin##* }"
    plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"

    if [ ! -d "$plugin_dir" ]; then
        print_info "Installing $plugin_name plugin..."
        git clone "$plugin_url" "$plugin_dir"
        print_success "$plugin_name plugin installed"
    else
        print_info "$plugin_name plugin already installed"
    fi
done

print_success "Dotfiles installation complete!"
print_info "Please restart your shell or run: source ~/.zshrc"
