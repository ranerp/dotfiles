# My Dotfiles

Personal configuration files for my development environment.

## Features
- **Zsh** with Oh My Zsh
- **Powerlevel10k** theme with auto-configuration (no wizard needed!)
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting, kubectl, fzf-zsh-plugin, fzf-tab, zsh-bat
- **Tools**: bat, fzf (upstream version), kubectl
- **Git** configuration with useful aliases
- **Nerd Fonts** (MesloLGS NF) automatically installed
- **DevContainer** configuration for consistent development environments

## Installation

### Manual Installation
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

### With DevContainers
This repository includes a complete devcontainer configuration in `.devcontainer/`:

**For VS Code:**
1. Install the "Dev Containers" extension
2. Open this repository in VS Code
3. Click "Reopen in Container" when prompted
4. Everything will be automatically set up!

**For PyCharm:**
1. Configure Docker/DevContainer support
2. Use the included `devcontainer.json` configuration
3. The dotfiles will be automatically installed

**Manual devcontainer usage:**
```bash
# Clone and use the devcontainer
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
# Use with your preferred devcontainer-compatible tool
```

### With Docker
```bash
# Use the devcontainer configuration
docker run -it --rm -v "$(pwd)":/workspaces/project mcr.microsoft.com/devcontainers/base:ubuntu
# Inside container:
git clone https://github.com/ranerp/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && chmod +x install.sh && ./install.sh
```

## What's Included

### Zsh Configuration
- Oh My Zsh with auto-configured Powerlevel10k theme
- No configuration wizard needed - works out of the box
- Useful plugins for development workflow
- Enhanced completion with fzf-tab
- Working fzf key bindings (Ctrl+R, Ctrl+T, Alt+C)

### Development Tools
- **fzf**: Fuzzy finder with full shell integration (installed from source)
- **bat**: Better `cat` with syntax highlighting
- **kubectl**: Kubernetes CLI with completion and aliases

### Git Configuration
- Useful aliases (st, co, br, etc.)
- No email configured globally (set per repository as needed)
- Better diff and merge tools
- Global gitignore patterns

### DevContainer Features
- Ubuntu-based development environment
- All tools pre-installed and configured
- Nerd Fonts included for proper prompt display
- Consistent setup across different machines
- Works with VS Code, PyCharm, and other devcontainer-compatible tools

### Key Features
- **fzf key bindings**:
  - `Ctrl+R`: Fuzzy command history search
  - `Ctrl+T`: File finder
  - `Alt+C`: Directory navigation
- **Enhanced tab completion** with fuzzy search
- **Git aliases**: `gst`, `gco`, `gp`, `gl`, etc.
- **Kubectl aliases**: `k`, `kgp`, `kgs`, etc.

## Font Configuration

The dotfiles automatically install MesloLGS NF (Nerd Font) in containers. For the best experience:

**Host Machine Setup:**
- **macOS**: `brew install font-meslo-lg-nerd-font`
- **Windows**: Download from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases)
- **Linux**: Fonts are installed automatically

**Configure your terminal/IDE:**
- Set font to "MesloLGS NF" in your terminal settings
- **VS Code**: Settings → Terminal Font Family → "MesloLGS NF"
- **PyCharm**: Settings → Editor → Color Scheme → Console Font → "MesloLGS NF"

## Customization

### Personal Information
Update `.gitconfig` with your details:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Running on remote server

```bash
ssh user@server 'curl -fsSL https://raw.githubusercontent.com/ranerp/dotfiles/main/remote-setup.sh | bash'
```

#### For frequent use

Add ~/.ssh/config

```text
Host myserver
    HostName some.domain.com
    User myuser
    ForwardAgent yes
    RemoteCommand "cd ~/.dotfiles && git pull && exec zsh"
```

### Environment Variables
Customize `.exports` for your preferences:
- `BAT_THEME`: Color theme for bat
- `FZF_DEFAULT_OPTS`: fzf appearance and behavior
- Add your own environment variables

### Aliases and Functions
- **`.aliases`**: Add your custom command shortcuts
- **`.functions`**: Add your custom shell functions

## DevContainer Configuration

The included `.devcontainer/devcontainer.json` provides:
- Ubuntu base image with common development tools
- Automatic dotfiles installation
- Proper font and terminal configuration
- All dependencies pre-installed
- Ready-to-use development environment

Perfect for:
- Consistent development environments
- Team collaboration
- Clean, isolated development setups
- Cross-platform development

## Troubleshooting

### fzf Key Bindings Not Working
The dotfiles install fzf from source (not apt) to ensure full compatibility:
- `Ctrl+R` should open fuzzy history search
- `Ctrl+T` should open file finder
- If not working, restart your shell: `exec zsh`

### Powerlevel10k Not Loading
- Ensure you're using a compatible terminal
- Check that MesloLGS NF font is configured
- Restart your terminal/shell

### DevContainer Issues
- Ensure Docker is running
- Rebuild container if needed
- Check that dotfiles repository is accessible

## Contributing

Feel free to fork and modify these dotfiles for your own use! The configuration is designed to be:
- **Cross-platform** (macOS, Linux, Windows with WSL)
- **Container-friendly** (Docker, devcontainers)
- **Modular** (easy to customize individual components)

## License

MIT License - Feel free to use and modify as needed!
