#!/bin/bash
# Quick remote server setup

echo "Setting up development environment..."

# Install basic dependencies
if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y git curl zsh
elif command -v yum &> /dev/null; then
    sudo yum install -y git curl zsh
elif command -v brew &> /dev/null; then
    brew install git curl zsh
fi

# Clone and install dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh

echo "Setup complete! Run 'exec zsh' to start using your environment"
