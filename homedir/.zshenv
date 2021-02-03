# PATH
export PATH=/usr/local/bin:$PATH

# Python
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# Node
export PATH="/usr/local/opt/node@12/bin:$PATH"

# Yarn
export PATH="$PATH:/.yarn/bin"

# Go
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
source "$HOME/.cargo/env"

# sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
