# ~/.zshrc

export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

export HISTSIZE=10000
export SAVEHIST=10000

export HISTFILE=~/.zsh_history

export EDITOR=vim

# NPM packages
export NPM_PACKAGES="$HOME/.npm/packages"
export PATH="$NPM_PACKAGES/bin:$PATH"

# Bun packages
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/home/user/.bun/_bun" ] && source "/home/user/.bun/_bun"

# Deno packages
export PATH="$HOME/.deno/bin:$PATH"

# Go packages
export PATH="$HOME/go/bin:$PATH"

# Rust packages
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

bindkey -e
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

eval "$(starship init zsh)"
