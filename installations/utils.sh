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

# Create local bin directory if it doesn't exist
create_local_bin() {
    if [ ! -d "$HOME/.local/bin" ]; then
        print_info "Creating ~/.local/bin directory..."
        mkdir -p "$HOME/.local/bin"
        print_success "Created ~/.local/bin directory"
    fi
}