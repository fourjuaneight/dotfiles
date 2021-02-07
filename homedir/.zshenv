export PATH="/opt/homebrew/bin:$PATH"

# Go
export GOPATH=$HOME/golang
export GOROOT="$(/opt/homebrew/bin/brew --prefix golang)/libexec"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
source "$HOME/.cargo/env"

# nvm
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
