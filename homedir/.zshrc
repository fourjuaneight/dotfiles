# History
HISTSIZE=10000
SAVEHIST=10000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"

  # Java
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Exo
export PATH=$PATH:$HOME/.exo/bin

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# fnm
export PATH=$HOME/.fnm:$PATH
eval "`fnm env`"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Sheldon
export SHELDON_CONFIG_DIR="$HOME/.config/sheldon"
export SHELDON_DATA_DIR="$SHELDON_CONFIG_DIR"
export SHELDON_CONFIG_FILE="$SHELDON_CONFIG_DIR/plugins.toml"
export SHELDON_LOCK_FILE="$SHELDON_CONFIG_DIR/plugins.lock"
export SHELDON_CLONE_DIR="$SHELDON_DATA_DIR/repos"
export SHELDON_DOWNLOAD_DIR="$SHELDON_DATA_DIR/downloads"

# Starship
export STARSHIP_CONFIG=~/.config/starship/config.toml

# zellij
export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

# GPG
export GPG_TTY=$(tty)

# Utils
export EDITOR=hx
eval "$(sheldon source)"
eval "$(starship init zsh)"
zsh-defer eval "$(atuin init zsh)"
zsh-defer eval "$(zoxide init zsh)"

# Rust Cargo
zsh-defer source "$HOME/.cargo/env"

# Colors
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi

# Autosuggestions
[[ -f ~/.zsh/autosuggestions.zsh ]] && zsh-defer source ~/.zsh/autosuggestions.zsh

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && zsh-defer source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/func.zsh ]] && zsh-defer source ~/.zsh/func.zsh
zmodload zsh/zprof

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# fnm
export PATH=/home/fourjuaneight/.fnm:$PATH
zsh-defer eval "`fnm env`"

# SKIM
export SKIM_DEFAULT_COMMAND="git ls-tree -r --name-only HEAD || rg --files || fd ."
