# Ensure completion is initialized
autoload -Uz compinit
compinit

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
  fzf
  copypath
)

# Increase timeout from default (usually 100ms)
ZSH_AUTOSUGGEST_EXECUTION_DELAY=1000  # 1 second

source $ZSH/oh-my-zsh.sh

# Aliases
# Modify ~/.zshrc
alias sz='source ~/.zshrc'
alias ez='lz ~/.zshrc'

cnf() {
  /usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

lzcnf() {
  lazygit --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}

alias lzg='lazygit'

# Only ignore autosuggest for 'config add' specifically, not all config commands
ZSH_AUTOSUGGEST_IGNORED_COMMANDS=('config add' 'config rm')
alias cst='config status'
alias cadd='config add'
alias crm='config rm --cached'
alias cpush='config push'

function fza() {
    local selected=$(alias | fzf)
    if [ -n "$selected" ]; then
        # Get alias name (before the =)
        local alias_name=$(echo "$selected" | cut -d= -f1)
        # Expand and execute the alias
        echo "Executing: $alias_name"
        eval "$alias_name"
    fi
}

# Nvim aliases
alias lz='XDG_CONFIG_HOME=~/neovim-distro NVIM_APPNAME=lazyvim nvim'
alias lzcf='XDG_CONFIG_HOME="$HOME/neovim-distro" NVIM_APPNAME=lazyvim nvim "$HOME/neovim-distro/lazyvim"'

# Custom interaction bindings.
alias t1="tree -a -L 1"
alias t2="tree -a -L 2"
alias t3="tree -a -L 3"

# Custom Git aliases.
alias gco='git checkout $(git branch --all | fzf)'
alias gbd='git branch --delete $(git branch | fzf)'

function gbc() {
    local query="$*"  # Join all arguments with spaces
    gba | fzf ${query:+--query="$query"} | sed 's/^[* ]*//' | tr -d ' ' | pbcopy
}

# fastfetch
alias ff='fastfetch'

# Tmux aliases

function tma() {
    local session
    session=$(tmux ls -F "#{session_name}" | fzf)

    if [ -z "$session" ]; then
        return 0
    fi

    if [ -z "$TMUX" ]; then
        set -x  # Enable command tracing
        tmux attach-session -t "$session"
        set +x  # Disable command tracing
    else
        set -x
        tmux switch-client -t "$session"
        set +x
    fi
}

tmd() {
    local confirm_flag=false
    local all_flag=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--confirm)
                confirm_flag=true
                shift
                ;;
            -a|--all)
                all_flag=true
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Usage: tmd [-c|--confirm] [-a|--all]"
                return 1
                ;;
        esac
    done
    
    local sessions
    
    if [ "$all_flag" = true ]; then
        # Get all sessions
        sessions=$(tmux ls -F "#{session_name}")
    else
        # Use fzf to select
        sessions=$(tmux ls -F "#{session_name}" | fzf --multi --prompt="Delete sessions (TAB for multiple): ")
    fi
    
    if [ -z "$sessions" ]; then
        return 0
    fi
    
    # Show what will be deleted
    echo "Sessions to delete:"
    echo "$sessions"
    
    # Confirm if flag is set
    if [ "$confirm_flag" = true ]; then
        echo -n "Confirm deletion? (y/N): "
        read -r confirm
        
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo "Cancelled."
            return 0
        fi
    fi
    
    # Delete sessions
    echo "$sessions" | while read -r session; do
        if [ -n "$session" ]; then
            tmux kill-session -t "$session"
            echo "Deleted: $session"
        fi
    done
}

# Server interactions
killport() {
    local selection
    selection=$(lsof -iTCP -sTCP:LISTEN -n -P | fzf --header="Select process to kill")
    
    if [ -z "$selection" ]; then
        return 0
    fi
    
    local pid
    pid=$(echo "$selection" | awk '{print $2}')
    
    if [ -n "$pid" ]; then
        kill -9 "$pid"
        echo "Killed process $pid"
    fi
}
#
# yazi shell wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

export FZF_DEFAULT_OPTS="
  --height=70%
  --border=rounded
  --preview-window=right:50%
  --layout=reverse
  --margin=5%,10%
"

# Load packages
export STARSHIP_CONFIG=~/.config/starship/starship.toml

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export PATH="$HOME/.yarn/bin:$PATH"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# opencode
export PATH=$HOME/.opencode/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Added by Antigravity IDE
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Wrapper for git, crontab, and other CLI tools that invoke $EDITOR
export EDITOR="env XDG_CONFIG_HOME=$HOME/neovim-distro NVIM_APPNAME=simple-nvim nvim"
export VISUAL="env XDG_CONFIG_HOME=$HOME/neovim-distro NVIM_APPNAME=simple-nvim nvim"
