# PATHS
export PATH=/usr/local/bin:$PATH

# Python PATH
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# RVM PATH
export PATH="$PATH:$HOME/.rvm/bin"

# rbenv PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads nvm bash_completion

# Node
export PATH="/usr/local/opt/node@12/bin:$PATH"

# Yarn
export PATH="$PATH:/.yarn/bin"

# Go PATH
export GOPATH="$HOME/golang"
export PATH="$PATH:/usr/local/go/bin"

# nnn
export NNN_FALLBACK_OPENER=xdg-open
export NNN_DE_FILE_MANAGER=nautilus
export NNN_USE_EDITOR=1
export EDITOR=nvim
