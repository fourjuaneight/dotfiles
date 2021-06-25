# common cli commands
alias cdh="cd ~"
alias cdm="cd /Volumes/Samuel"
alias cdr="cd /Volumes/Sergio/Repos"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias .........="cd ../../../../../../../.."
alias cl="clear"
alias dot="cd ~/dotfiles"
alias tree="tree -I node_modules"
alias usesam="lsof | grep /Volumes/Samuel"
alias useserg="lsof | grep /Volumes/Sergio"

# common variations of 'cat' command
alias cat="bat"

# common variations of 'ls' command
alias ls="exa"
alias ll="exa -l"
alias la="exa -a"

# search history
alias hgrep="history | ag"

# enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# nettop status
alias netstatus="nettop -P -k state,interface -d"

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

# ssh
alias rssh="sudo service ssh --full-restart"
alias stsh="sudo service ssh start"
alias spsh="sudo service ssh stop"

# Docker
alias dcku="clear && docker-compose up"
alias dckb="clear && docker-compose build"
alias dckdrm="clear && docker-compose down -s"

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

alias gdf="git diff"
alias gdfn="git diff --name-only"
alias gdfs="git diff --staged"

alias grst="git reset"
alias grsth="git reset --hard"

alias gsta="git stash"
alias gstap="git stash pop"

alias gts="git tag -s"
alias gtv="git tag | sort -V"

# system update
alias rup="rustup update"
alias cup="cargo install-update -a"
alias bup="brew update"
alias bug="brew upgrade && brew cleanup"
alias zup="zplug update"
alias vug="vim +PlugUpgrade +PlugUpdate +qa"
