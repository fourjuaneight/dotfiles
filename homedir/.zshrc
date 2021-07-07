# ENV
source "${HOME}/.zshenv"

# Utils
eval "$(sheldon source)"
eval "$(starship init zsh)"
zsh-defer eval "$(zoxide init zsh)"

# Rust Cargo
zsh-defer source "$HOME/.cargo/env"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Colors
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi


# Autosuggestions
[[ -f ~/.zsh/autosuggestions.zsh ]] && zsh-defer source ~/.zsh/autosuggestions.zsh

# fzf
[[ -f ~/.zsh/fzf.zsh ]] && zsh-defer source ~/.zsh/fzf.zsh

_fzf_compgen_path() {
  fd -HL -E ".git" . "$1"
}

# Aliases
[[ -f ~/.zsh/aliases.zsh ]] && zsh-defer source ~/.zsh/aliases.zsh

# Functions
[[ -f ~/.zsh/func.zsh ]] && zsh-defer source ~/.zsh/func.zsh
zmodload zsh/zprof

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
