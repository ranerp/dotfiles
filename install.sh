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
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

print_info "Installing dotfiles from $DOTFILES_DIR"

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        print_info "Already linked: $target"
        return
    fi
    
    if [ -e "$target" ]; then
        print_info "Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    ln -s "$source" "$target"
    print_success "Linked $source -> $target"
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    print_info "Installing Nerd Fonts (MesloLGS NF)..."
    
    # Create fonts directory
    mkdir -p ~/.local/share/fonts
    
    # Download MesloLGS NF (recommended by Powerlevel10k)
    cd /tmp
    
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
    if command -v fc-cache &> /dev/null; then
        print_info "Updating font cache..."
        fc-cache -fv > /dev/null 2>&1
    fi
    
    print_success "Nerd Fonts installed"
    print_info "Note: Configure your terminal to use 'MesloLGS NF' font for best experience"
}

# Create symlinks for dotfiles
files=(".zshrc" ".p10k.zsh" ".gitconfig" ".aliases" ".functions" ".exports")

for file in "${files[@]}"; do
    if [ -f "$DOTFILES_DIR/$file" ]; then
        create_symlink "$DOTFILES_DIR/$file" "$HOME/$file"
    fi
done

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
else
    print_info "Oh My Zsh already installed"
fi

# Install Nerd Fonts
install_nerd_fonts

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    print_info "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    print_success "Powerlevel10k theme installed"
else
    print_info "Powerlevel10k theme already installed"
fi

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
