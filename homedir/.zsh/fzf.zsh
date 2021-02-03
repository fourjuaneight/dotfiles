# Setup fzf
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
[[ $- == *i* ]] && source "~/.zsh/completions/completion.zsh" 2> /dev/null

# Key bindings
source "~/.zsh/bindings/key-bindings.zsh"
