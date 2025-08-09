# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins to load
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    kubectl
    fzf-zsh-plugin  
    fzf-tab
    zsh-bat
    you-should-use
    colored-man-pages
    history-substring-search
    copypath
    zsh-completions
    z
    docker
    docker-compose
    npm
    pip
    rust
    terraform
    aws
    helm
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
#
# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Load additional configuration files
[[ -f ~/.exports ]] && source ~/.exports
[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# Load Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# fzf-tab configuration
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Enable completion for kubectl
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh) 2>/dev/null || true
    # Alias k to kubectl for faster typing
    alias k=kubectl
    complete -F __start_kubectl k
fi

# Configure bat theme
export BAT_THEME="Coldark-Dark"

# Better ls colors
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Load direnv if available
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Load fzf key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
