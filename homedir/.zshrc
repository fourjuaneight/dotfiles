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

# frum
eval "$(frum init)"

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

if [[ "$OSTYPE" != "darwin"* ]]; then
  # Coreutils
  export PATH=/usr/lib/cargo/bin/coreutils:$PATH
fi

# GPG
export GPG_TTY=$(tty)

# Utils
export EDITOR=hx
eval "$(sheldon source)"
eval "$(starship init zsh)"
zsh-defer eval "$(atuin init zsh)"
zsh-defer eval "$(zoxide init zsh)"
# zsh-defer eval "$(github-copilot-cli alias -- "$0")"

# Rust Cargo
zsh-defer source "$HOME/.cargo/env"

# Colors
if [[ $TERM == xterm ]]; then
  export TERM=xterm-256color
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

# pyenv
PATH=$(pyenv root)/shims:$PATH
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# fzf
export FZF_DEFAULT_OPTS="
    --height=99%
    --layout=reverse
    --pointer='█'
    --scrollbar='▌'
    --highlight-line
    --color=hl:#f3be7c
    --color=bg:-1
    --color=gutter:-1
    --color=bg+:#252530
    --color=fg+:#aeaed1
    --color=hl+:#f3be7c
    --color=border:#606079
    --color=prompt:#bb9dbd
    --color=query:#aeaed1:bold
    --color=pointer:#aeaed1
    --color=scrollbar:#aeaed1
    --color=info:#f3be7c
    --color=spinner:#7fa563
    "
