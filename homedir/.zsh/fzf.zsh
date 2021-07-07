# Setup fzf
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
[[ $- == *i* ]] && zsh-defer source "${HOME}/.zsh/completions/completion.zsh" 2> /dev/null

# Key bindings
zsh-defer source "${HOME}/.zsh/bindings/key-bindings.zsh"
