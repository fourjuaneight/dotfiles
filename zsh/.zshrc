# PATHS
export PATH=/usr/local/bin:$PATH

# Load Linux Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Python PATH
export PYTHONPATH="/usr/lib/python3/dist-packages:$PYTHONPATH"

# RVM PATH
export PATH="$PATH:$HOME/.rvm/bin"

# Load nvm
export NVMPATH="$HOME/.nvm"
[[ -s $NVMPATH/nvm.sh ]] && . $NVMPATH/nvm.sh

# Loading Antigen-hs
. ~/.zsh/antigen-hs/init.zsh

# Loading zsh Autosuggestions
source ~/.zsh/zsh-autosuggestions.zsh

# Load fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set name of the theme to load
ZSH_THEME=""

# Loading Pure prompt
autoload -U promptinit; promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f '
prompt pure

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

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

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Load aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Load functions
[[ -f ~/.zfunc ]] && source ~/.zfunc
