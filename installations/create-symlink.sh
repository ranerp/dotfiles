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