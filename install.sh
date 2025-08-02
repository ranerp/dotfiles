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

# Install k9s if kubectl is available
install_k9s() {
    if command -v kubectl &> /dev/null; then
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

# Install eza (modern ls replacement)
install_eza() {
    print_info "Installing eza (modern ls replacement)..."
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) EZA_ARCH="x86_64" ;;
        aarch64|arm64) EZA_ARCH="aarch64" ;;
        *) EZA_ARCH="x86_64" ;;
    esac
    
    # Get latest eza release
    EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -n "$EZA_VERSION" ]; then
        cd /tmp
        wget -q "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        tar -xzf "eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        sudo mv eza /usr/local/bin/
        rm -f "eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz"
        print_success "eza installed (${EZA_VERSION})"
    else
        print_error "Failed to get eza version"
    fi
}

# Create symlinks for dotfiles
files=(".zshrc" ".p10k.zsh" ".gitconfig" ".aliases" ".functions" ".exports" ".tmux.conf" ".vimrc")

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

# Install k9s
install_k9s

# Install fzf shell integration
install_fzf_shell_integration

# Install eza
install_eza

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
