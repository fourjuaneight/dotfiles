# PATHS
export PATH=/usr/local/bin:$PATH

# Load Linux Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Snap
export PATH=$PATH:/snap/bin

# PKG
export PKG_CONFIG_PATH=/usr/lib/pkgconfig 

# Python PATH
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# RVM PATH
export PATH="$PATH:$HOME/.rvm/bin"

# rbenv PATH
export PATH="$HOME.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm PATH
export NVMPATH="$HOME/.nvm"
[[ -s $NVMPATH/nvm.sh ]] && . $NVMPATH/nvm.sh

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
