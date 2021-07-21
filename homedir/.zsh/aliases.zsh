# common cli commands
alias cd="z"
alias cdh="z ~"
alias cdm="z /Volumes/Samuel"
alias cdr="z /Volumes/Sergio/Repos"
alias ..="z .."
alias ...="z ../.."
alias ....="z ../../.."
alias .....="z ../../../.."
alias ......="z ../../../../.."
alias .......="z ../../../../../.."
alias ........="z ../../../../../../.."
alias .........="z ../../../../../../../.."
alias cl="clear"
alias dot="z ~/dotfiles"
alias tree="tree -I node_modules"
alias usesam="lsof | rg /Volumes/Samuel"
alias useserg="lsof | rg /Volumes/Sergio"
alias ping="gping -s"
alias du="dust"
alias htop="btm"
alias gtop="btm"
alias hiccup="czkawka_cli"

# common variations of 'cat' command
alias cat="bat"

# common variations of 'ls' command
alias ls="exa"
alias ll="exa -l"
alias la="exa -a"

# search history
alias hgrep="history | ag"

# networking
alias whois="whois -h whois-servers.net"
alias netstatus="sudo bandwhich -n"
alias dig="dog"

# zsh
alias zconf="vim ~/.zshrc"
alias zsour="source ~/.zshrc"

# nnn
alias n="nnn"

# emacs
alias emacst="emacs -nw"

# doom
alias doom="~/.emacs.d/bin/doom"

# vim
alias vi="vim"
alias vconf="vim ~/.vimrc"
alias vsour="vim source ~/.vimrc"

# cron
alias croe="crontab -e"
alias crol="crontab -l"

# zellij
alias tmux="zellij"
alias zconf="vim ~/.config/zellij/config.yml"
alias zdev="zellij --layout ~/.config/zellij/layout.dev.yaml"
alias zgit="zellij --layout ~/.config/zellij/layout.git.yaml"

# ssh
alias rssh="sudo service ssh --full-restart"
alias stsh="sudo service ssh start"
alias spsh="sudo service ssh stop"

# Webpack
alias wpw="webpack -w"
alias wp="webpack"

# nvm
alias nvi="nvm install"
alias nvu="nvm use"
alias nviu="nvm install && nvm use --delete-prefix"
alias nr="npm run"

# Postgres
alias psl="psql postgres -h localhost -l"

# Git
alias ga="git add"
alias gaa="git add --all"
alias gap="git add --patch"

alias gcm="git commit -S -m"
alias gc="git commit -S"

alias gf="git fetch"

alias gup="git push"

alias gp="git pull --rebase"
alias gsp="git stash && git pull --rebase && git stash pop"

alias gst="git status"
alias gstat="onefetch ."

alias gdf="git diff"
alias gdfn="git diff --name-only"
alias gdfs="git diff --staged"

alias grst="git reset"
alias grsth="git reset --hard"

alias gsta="git stash"
alias gstap="git stash pop"

alias gts="git tag -s"
alias gtv="git tag | sort -V"

alias ggc="git gc --aggressive --prune"

# system update
alias rup="rustup update"
alias cup="cargo install-update -a"
alias bup="brew update"
alias bug="brew upgrade && brew cleanup"
alias vug="vim +PlugUpgrade +PlugUpdate +qa"
