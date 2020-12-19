# Load zplug
source "${HOME}/.zplug/init.zsh"

zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-history-substring-search"
zplug "zdharma/history-search-multi-word"
zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

if ! zplug check --verbose; then
  printf "Install? [y/N]: "

  if read -q; then
    echo
    zplug install
  else
    echo
  fi
fi

zplug load

# Loading Pure prompt
autoload -U promptinit
promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='λ'

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
