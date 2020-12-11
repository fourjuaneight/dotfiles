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
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Loading Pure prompt
autoload -U promptinit; promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='λ'
prompt pure
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ssh-agent)

# Load aliases
[[ -f ~/aliases.zsh ]] && source ~/aliases.zsh

# Load functions
[[ -f ~/zfunc.zsh ]] && source ~/zfunc.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fourjuaneight/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fourjuaneight/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fourjuaneight/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fourjuaneight/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export YVM_DIR=/usr/local/opt/yvm
[ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh
