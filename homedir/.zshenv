# PATH
export PATH=/usr/local/bin:$PATH

# Python
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# RVM
export PATH="$PATH:$HOME/.rvm/bin"

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

# nnn
export NNN_FALLBACK_OPENER=xdg-open
export NNN_DE_FILE_MANAGER=nautilus
export NNN_USE_EDITOR=1
export EDITOR=macvim

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# yvm
export YVM_DIR=/usr/local/opt/yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh
