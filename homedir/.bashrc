# Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH=$PATH:$HOME/.exo/bin

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# fnm
export PATH=$HOME/.fnm:$PATH
eval "`fnm env`"

# Sheldon
export SHELDON_CONFIG_DIR="$HOME/.config/sheldon"
export SHELDON_DATA_DIR="$SHELDON_CONFIG_DIR"
export SHELDON_CONFIG_FILE="$SHELDON_CONFIG_DIR/plugins.toml"
export SHELDON_LOCK_FILE="$SHELDON_CONFIG_DIR/plugins.lock"
export SHELDON_CLONE_DIR="$SHELDON_DATA_DIR/repos"
export SHELDON_DOWNLOAD_DIR="$SHELDON_DATA_DIR/downloads"

# Starship
export STARSHIP_CONFIG=~/.config/starship/config.toml

# fzf
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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

# SKIM
export SKIM_DEFAULT_COMMAND="git ls-tree -r --name-only HEAD || rg --files || fd ."
