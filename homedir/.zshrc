
#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####
# ENV
source "${HOME}/.zshenv"

# GPG
export GPG_TTY=$(tty)

# Utils
eval "$(sheldon source)"
eval "$(starship init zsh)"
zsh-defer eval "$(zoxide init zsh)"

# Rust Cargo
zsh-defer source "$HOME/.cargo/env"

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

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
