# Auto-completion
[[ $- == *i* ]] && zsh-defer source "${HOME}/.zsh/completions/completion.zsh" 2> /dev/null

# Key bindings
zsh-defer source "${HOME}/.zsh/bindings/key-bindings.zsh"
