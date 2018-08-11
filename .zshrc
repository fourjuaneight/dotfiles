export GOPATH=$HOME/Code/go
PATH=$PATH:$GOPATH/bin

echo 'source ~/.zsh/antigen-hs/init.zsh' | tee -a ~/.zshrc | env zsh

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /Users/administrator/.rvm/scripts/rvm

# Set name of the theme to load
ZSH_THEME=""

autoload -U promptinit; promptinit
PURE_GIT_DOWN_ARROW='↑'
PURE_GIT_UP_ARROW='↓'
PROMPT='%(1j.[%j] .)%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯}%f '
prompt pure

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Aliases
alias zco="vim ~/.zshrc"
alias zso="source ~/.zshrc"

alias vco="vim ~/.vimrc"
alias vso="source ~/.vimrc"

alias tco="vim ~/.tmux.conf"
alias tso="source ~/.tmux.conf"

alias tn='tmux -u new'
alias tk='pkill -f tmux'
alias tx='exit'

alias hs='hugo server'
alias hsd='hugo server --disableFastRender'

alias js='jekyll serve'

alias rs='rails s'

alias g='git'
alias ghh='git help'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gap='git apply'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'

alias gc='git commit -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gco='git checkout'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias gm='git merge'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpu='git push upstream'

alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias glum='git pull upstream master'

alias gr='git remote'
alias gra='git remote add'
alias grup='git remote update'
alias grv='git remote -v'

alias grh='git reset'
alias grhh='git reset --hard'

alias gst='git status'
alias gsb='git status -sb'
alias gss='git status -s'

alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias gts='git tag -s'
alias gtv='git tag | sort -V'

ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}
# compdef _git ggu=git-checkout

# alias ggpur='ggu'
# compdef _git ggpur=git-checkout

# alias ggpull='git pull origin $(git_current_branch)'
# compdef _git ggpull=git-checkout

# alias ggpush='git push origin $(git_current_branch)'
# compdef _git ggpush=git-checkout

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'


# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

fbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='ag --ignore *.pyc -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"