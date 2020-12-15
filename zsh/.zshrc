# Load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
  zgen load hlissner/zsh-autopair autopair.zsh develop
  zgen load zsh-users/zsh-history-substring-search
  zgen load zdharma/history-search-multi-word
  zgen load zsh-users/zsh-completions
  zgen load zdharma/fast-syntax-highlighting
  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure

  zgen save
fi

# Loading Pure prompt
autoload -U promptinit
promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='λ'
prompt pure

# Loading zsh Autosuggestions
[[ -f ~/.zsh/zsh-autosuggestions.zsh ]] && source ~/.zsh/zsh-autosuggestions.zsh

# Load fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Load aliases
[[ -f ~/aliases.zsh ]] && source ~/aliases.zsh

# Load functions
[[ -f ~/zfunc.zsh ]] && source ~/zfunc.zsh
