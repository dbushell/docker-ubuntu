# ~/.zshrc

export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

export HISTSIZE=10000
export SAVEHIST=10000

export HISTFILE=~/.zsh_history

export EDITOR=vim

export NPM_PACKAGES="$HOME/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"

setopt append_history
setopt share_history

eval "$(starship init zsh)"
