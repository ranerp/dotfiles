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

ensure_brew() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        return
    fi

    if command -v brew >/dev/null 2>&1; then
        print_info "Homebrew already installed"
        return
    fi

    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for the rest of this session (Apple Silicon vs Intel)
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

ensure_wget() {
    if command -v wget >/dev/null 2>&1; then
        return
    fi

    print_info "Installing wget..."
    case "$(uname -s)" in
        Darwin)
            brew install wget
            ;;
        Linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y wget
            else
                print_error "Cannot install wget — unsupported package manager"
                return 1
            fi
            ;;
    esac
    print_success "wget installed"
}

# Create local bin directory if it doesn't exist
create_local_bin() {
    if [ ! -d "$HOME/.local/bin" ]; then
        print_info "Creating ~/.local/bin directory..."
        mkdir -p "$HOME/.local/bin"
        print_success "Created ~/.local/bin directory"
    fi
}