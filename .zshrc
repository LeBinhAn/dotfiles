export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias config=/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME
eval "$(zoxide init zsh)"
