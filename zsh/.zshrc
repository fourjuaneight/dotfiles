# PATHS
export PATH=/usr/local/bin:$PATH

# Load Linux Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Python PATH
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# RVM PATH
export PATH="$PATH:$HOME/.rvm/bin"

# nvm PATH
export NVMPATH="$HOME/.nvm"
[[ -s $NVMPATH/nvm.sh ]] && . $NVMPATH/nvm.sh

# Go PATH
export GOPATH="$HOME/golang"
export PATH="$PATH:/usr/local/go/bin"

# Load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then

  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load zsh-users/zsh-history-substring-search
  zgen load zdharma/history-search-multi-word
  zgen load zsh-users/zsh-completions src
  zgen load zdharma/fast-syntax-highlighting
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

  zgen save
fi

# Loading zsh Autosuggestions
source ~/.zsh/zsh-autosuggestions.zsh

# Load fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Set name of the theme to load
ZSH_THEME=""

# Loading Pure prompt
autoload -U promptinit; promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-λ}%f '
prompt pure

# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent)

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='vim'
# fi

# Use nvim as the default editor
export EDITOR=nvim

# Load aliases
[[ -f ~/aliases.zsh ]] && source ~/aliases.zsh

# Load functions
[[ -f ~/zfunc.zsh ]] && source ~/zfunc.zsh
