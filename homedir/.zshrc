# Completions
fpath=(~/.zsh/completions $fpath)

# ENV
source "${HOME}/.zshenv"
eval "$(zoxide init zsh)"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Colors
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi

# zplug
source "${HOME}/.zplug/init.zsh"

zplug "hlissner/zsh-autopair", defer:2
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
export FZF_DEFAULT_COMMAND="rga --files --no-ignore-vcs --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

_fzf_compgen_path() {
  fd -HL -E ".git" . "$1"
}

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/func.zsh ]] && source ~/.zsh/func.zsh
zmodload zsh/zprof
