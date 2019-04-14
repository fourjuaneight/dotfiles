# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/fourjuaneight/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/fourjuaneight/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/fourjuaneight/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/fourjuaneight/.fzf/shell/key-bindings.zsh"

