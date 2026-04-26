#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$PWD"
if [ ! -f "$DOTFILES_DIR/install.sh" ]; then
  print_error "Please run this script from the dotfiles directory"
  exit 1
fi

# Source installation scripts explicitly
source "$DOTFILES_DIR/installations/utils.sh"
source "$DOTFILES_DIR/installations/create-symlink.sh"
source "$DOTFILES_DIR/installations/fonts.sh"
source "$DOTFILES_DIR/installations/k9s.sh"
source "$DOTFILES_DIR/installations/fzf-shell-integration.sh"
source "$DOTFILES_DIR/installations/eza.sh"
source "$DOTFILES_DIR/installations/bat.sh"
source "$DOTFILES_DIR/installations/helix.sh"
source "$DOTFILES_DIR/installations/ohmyzsh.sh"
source "$DOTFILES_DIR/installations/powerlevel10k.sh"
source "$DOTFILES_DIR/installations/setup-global-gitignore.sh"

print_info "Installing dotfiles from $DOTFILES_DIR"

# Create symlinks for dotfiles
print_info "Setting up dotfiles symlinks..."
files=(".zshrc" ".p10k.zsh" ".gitconfig" ".aliases" ".functions" ".exports" ".tmux.conf" ".vimrc")

for file in "${files[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# Installation configuration - set to false to disable
declare -A INSTALL_CONFIG=(
    ["k9s"]=true
    ["fzf"]=true
    ["eza"]=true
    ["bat"]=true
    ["helix"]=true
    ["ohmyzsh"]=true
    ["powerlevel10k"]=true
    ["fonts"]=true            # powerlevel10k depends on the NerdFonts to render correctly. Same can be said about EZA
)

# Create local bin directory
create_local_bin

# Install Oh My Zsh first (required for themes/plugins)
if [ "${INSTALL_CONFIG["ohmyzsh"]}" = "true" ]; then
    install_ohmyzsh
else
    print_info "Skipping Oh My Zsh (disabled)"
fi

# Install Nerd Fonts
if [ "${INSTALL_CONFIG["fonts"]}" = "true" ]; then
    install_nerd_fonts
else
    print_info "Skipping Nerd Fonts (disabled)"
fi

# Install k9s
if [ "${INSTALL_CONFIG["k9s"]}" = "true" ]; then
    install_k9s
else
    print_info "Skipping k9s (disabled)"
fi

# Install fzf
if [ "${INSTALL_CONFIG["fzf"]}" = "true" ]; then
    install_fzf_shell_integration
else
    print_info "Skipping fzf (disabled)"
fi

# Install eza
if [ "${INSTALL_CONFIG["eza"]}" = "true" ]; then
    install_eza
    setup_eza_themes
else
    print_info "Skipping eza (disabled)"
fi

# Install bat
if [ "${INSTALL_CONFIG["bat"]}" = "true" ]; then
    install_bat
else
    print_info "Skipping bat (disabled)"
fi

# Install Helix
if [ "${INSTALL_CONFIG["helix"]}" = "true" ]; then
    install_helix
    setup_helix_config
else
    print_info "Skipping Helix (disabled)"
fi

# Setup configurations
setup_global_gitignore

# Install Powerlevel10k theme
if [ "${INSTALL_CONFIG["powerlevel10k"]}" = "true" ]; then
    install_powerlevel10k
else
    print_info "Skipping Powerlevel10k (disabled)"
fi

# Install plugins
plugins=(
    "zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "fzf-zsh-plugin https://github.com/unixorn/fzf-zsh-plugin.git"
    "fzf-tab https://github.com/Aloxaf/fzf-tab"
    "zsh-bat https://github.com/fdellwing/zsh-bat.git"
    "you-should-use https://github.com/MichaelAquilina/zsh-you-should-use.git"
    "history-substring-search https://github.com/zsh-users/zsh-history-substring-search.git"
    "zsh-completions https://github.com/zsh-users/zsh-completions.git"
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
