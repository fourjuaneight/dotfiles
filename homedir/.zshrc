# Completions
fpath=(~/.zsh/completions $fpath)

# ENV
source "${HOME}/.zshenv"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# zplug
source "${HOME}/.zplug/init.zsh"

zplug "hlissner/zsh-autopair", defer:2
zplug "zsh-users/zsh-history-substring-search"
zplug "zdharma/history-search-multi-word"
zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

zplug load

# Pure prompt
autoload -U promptinit
promptinit
PURE_GIT_DOWN_ARROW='↓'
PURE_GIT_UP_ARROW='↑'
PURE_PROMPT_SYMBOL='λ'

# Autosuggestions
[[ -f ~/.zsh/autosuggestions.zsh ]] && source ~/.zsh/autosuggestions.zsh

# fzf
[[ -f ~/.zsh/fzf.zsh ]] && source ~/.zsh/fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/func.zsh ]] && source ~/.zsh/func.zsh
