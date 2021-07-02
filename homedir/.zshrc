# Completions
fpath=(~/.zsh/completions $fpath)

# ENV
source "${HOME}/.zshenv"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Colors
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi

# Utils
eval "$(sheldon source)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Autosuggestions
[[ -f ~/.zsh/autosuggestions.zsh ]] && source ~/.zsh/autosuggestions.zsh

# fzf
[[ -f ~/.zsh/fzf.zsh ]] && source ~/.zsh/fzf.zsh

_fzf_compgen_path() {
  fd -HL -E ".git" . "$1"
}

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/func.zsh ]] && source ~/.zsh/func.zsh
zmodload zsh/zprof

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
