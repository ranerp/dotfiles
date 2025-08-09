# My Dotfiles

Personal configuration files for my development environment.

## Features
- **Zsh** with Oh My Zsh
- **Powerlevel10k** theme with auto-configuration (no wizard needed!)
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting, kubectl, fzf-zsh-plugin, fzf-tab, zsh-bat, you-should-use, colored-man-pages, history-substring-search, copypath, zsh-completions, z
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

#### VS Code Setup
1. **Install Prerequisites:**
   - Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Install the ["Dev Containers" extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) in VS Code

2. **Open in Container:**
   ```bash
   # Clone any project (doesn't need to include dotfiles)
   git clone https://github.com/yourproject/repo.git
   cd repo
   
   # Copy the .devcontainer folder from this dotfiles repo
   curl -L https://github.com/ranerp/dotfiles/archive/main.zip | tar -xz --strip=1 dotfiles-main/.devcontainer
   
   # Open in VS Code
   code .
   ```
   - VS Code will detect the devcontainer configuration
   - Click "Reopen in Container" when prompted  
   - Wait for the container to build and dotfiles to install (~5-8 minutes first time)
   - Your dotfiles will be automatically cloned and configured!

#### PyCharm Setup
1. **Install Prerequisites:**
   - Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Enable Docker plugin in PyCharm

2. **Configure DevContainer:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```
   - Open PyCharm → File → Open → Select the dotfiles folder
   - Go to Settings → Build, Execution, Deployment → Docker
   - Add Docker server (usually auto-detected)
   - Go to Settings → Build, Execution, Deployment → Remote Development
   - Create new SSH configuration using the devcontainer

#### Manual Docker Usage
```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Build and run the devcontainer
docker build -f .devcontainer/Dockerfile -t my-dotfiles .
docker run -it --rm -v "$(pwd)":/workspaces/dotfiles -v /var/run/docker.sock:/var/run/docker.sock my-dotfiles

# Or use docker-compose for easier management
cd .devcontainer
docker-compose up -d
docker exec -it dotfiles_devcontainer zsh

# When done
docker-compose down

# Inside container, dotfiles are already installed and configured!
```

#### DevContainer CLI (devcontainer/cli)
```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Build and open the devcontainer
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . zsh
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
- **Helix**: Modern modal text editor with LSP support

### Git Configuration
- Useful aliases (st, co, br, etc.)
- No email configured globally (set per repository as needed)
- Helix configured as default editor and diff/merge tool
- OneDark color scheme for git output
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
- **Enhanced tab completion** with fuzzy search via fzf-tab
- **Smart directory jumping** with `z` plugin
- **Alias reminders** with `you-should-use` plugin
- **History substring search** with Up/Down arrows
- **Comprehensive completions** for Docker, npm, pip, terraform, aws, gcloud, helm
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
