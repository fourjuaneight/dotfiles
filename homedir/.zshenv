eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH=$PATH:$HOME/.exo/bin

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# fnm
export PATH=$HOME/.fnm:$PATH
eval "`fnm env`"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_LAZY_LOAD=true
export PATH=~/.npm-global/bin:$PATH

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
export FZF_DEFAULT_COMMAND="rga --files --no-ignore-vcs --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
