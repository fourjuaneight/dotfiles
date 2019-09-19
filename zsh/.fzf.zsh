# Setup fzf
# ---------
if [[ ! "$PATH" == */home/fourjuaneight/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/fourjuaneight/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/fourjuaneight/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/fourjuaneight/.fzf/shell/key-bindings.zsh"
