# common cli commands
alias cdh="cd ~"
alias cds="cd /Volumes/Samuel"
alias cdr="cd /Volumes/Samuel/Repos"
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
alias win="cd /mnt/c/Users/Juan"
alias exd="cd /mnt/d/"
alias tree="tree -I node_modules"

# Common variations of 'ls' command
alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias sl="ls"
alias l="ls"
alias s="ls"

# Search history
alias hgrep="history | ag"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# zsh
alias vi="vim"
alias zco="vim ~/.zshrc"
alias zso="source ~/.zshrc"
alias dl="rm"
alias dldr="rm -rf"

# nnn
alias n="nnn"

# emacs
alias emacst="emacs -nw"

# doom
alias doom="~/.emacs.d/bin/doom"

# vim
alias vi="vim"
alias vco="vim ~/.vimrc"
alias vso="vim source ~/.vimrc"

# Cron
alias croe="crontab -e"
alias crol="crontab -l"

# tmux
alias tco="vim ~/.tmux.conf"
alias tso="tmux source ~/.tmux.conf"
alias tn="tmux -u new"
alias tk="pkill -f tmux"
alias tx="exit"
alias tdevx="tmux new-session \; split-window -v -p 20 \; send-keys 'clear' C-m \; split-window -h \; send-keys 'clear' C-m \; select-pane -U \; send-keys 'vim' C-m \;"
alias tdev="tmux new-session \; split-window -v -p 20 \; send-keys 'clear' C-m \; select-pane -U \; send-keys 'vim' C-m \;"
alias tter="tmux new-session \; split-window -h \; send-keys 'clear' C-m \; select-pane -L \; send-keys 'clear' C-m \;"

# ssh
alias rssh="sudo service ssh --full-restart"
alias stsh="sudo service ssh start"
alias spsh="sudo service ssh stop"

# youtube-dl
alias yt="youtube-dl"
alias ytf="youtube-dl -F"
alias ytba="youtube-dl -f 'bestaudio[ext=m4a]'"
alias ytbv="youtube-dl -f \'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio\' --merge-output-format mp4"

# glyphhanger
alias glhu="glyphhanger --US_ASCII --formats=woff2,woff --subset=*.ttf"
alias glha="glyphhanger --LATIN --formats=woff2,woff --subset=*.ttf"

# Docker
alias dcu="docker-compose up"
alias dcb="docker-compose build"
alias dcrm="docker-compose down -s"

# Gulp
alias gub="gulp build"
alias guw="gulp watch"
alias guc="gulp critical"
alias gu="gulp"

# Webpack
alias wpw="webpack -w"
alias wp="webpack"

# nvm
alias ni="nvm install"
alias nu="nvm use"
alias niu="nvm install;nvm use --delete-prefix"
alias nr="npm run"

# Hugo
alias hs="hugo server"
alias hsd="hugo server --disableFastRender"
alias shs="concurrently \"hugo serve --disableFastRender\" \"gulp watch\""

# Jekyll
alias js="bundle exec jekyll serve"

# mySQL
alias msrs="mysql.server restart"
alias msst="mysql.server stop"
alias mss="mysql.server start"
alias psl="psql postgres -h localhost -l"
alias rc="bundle exec rails c"
alias rs="rails s"

# Dev
alias dlnm="rm -rf node_modules"
alias dlh="rm -rf public resources"
alias dlj="rm -rf _public"
alias rin="rm -rf node_modules package-lock.json && npm install"
alias riny="rm -rf node_modules yarn.lock && yarn install"

# Git
alias gco="sudo vim ~/.ssh/config"

alias g="git"
alias ghh="git help"

alias ga="git add"
alias gaa="git add --all"
alias gaacm="git add --all && git commit -S -m"
alias gapa="git add --patch"
alias gau="git add --update"
alias gap="git apply"

alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbl="git blame -b -w"
alias gbnm="git branch --no-merged"
alias gbr="git branch --remote"

alias gc="git commit"
alias gcm="git commit -S -m"
alias gcb="git checkout -b"
alias gcf="git config --list"
alias gcl="git clone --recursive"
alias gco="git checkout"

alias gd="git diff"
alias gdca="git diff --cached"
alias gdcw="git diff --cached --word-diff"
alias gdt="git diff-tree --no-commit-id --name-only -r"
alias gdw="git diff --word-diff"

alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gfo="git fetch origin"
alias gfu="git fetch upstream"

alias gm="git merge"
alias gmnff="git merge --no-ff"
alias grnff="git rebase --no-ff"
alias gmom="git merge origin/master"
alias grom="git merge origin/master"
alias gmt="git mergetool --no-prompt"
alias gmum="git merge upstream/master"
alias grum="git rebase upstream/master"
alias gmab="git merge --abort"

alias gup="git push"
alias gupd="git push --dry-run"
alias gupu="git push upstream"

alias gp="git pull --rebase"
alias gpv="git pull --rebase -v"
alias gpum="git pull --rebase upstream master"
alias gsp="git pull --recurse-submodules"

alias gr="git remote"
alias gra="git remote add"
alias grup="git remote update"
alias grv="git remote -v"

alias grhom="git reset --hard origin/master"
alias grhd="git reset HEAD^"
alias gsrh="git submodule foreach 'git reset --hard'"

alias gst="git status"
alias gsb="git status -sb"
alias gss="git status -s"

alias gsta="git stash"
alias gstaa="git stash apply"
alias gstac="git stash clear"
alias gstad="git stash drop"
alias gstal="git stash list"
alias gstap="git stash pop"
alias gstas="git stash show --text"

alias gts="git tag -s"
alias gtv="git tag | sort -V"

alias glm="git log --pretty=oneline --abbrev-commit origin/master"
alias grb="git rebase -i HEAD~5"
alias gpfl="git push --force-with-lease"

# Homebrew
alias bru="brew update"
alias brup="brew upgrade"

# apt-get
alias agu="sudo apt-get update"
alias agup="sudo apt-get upgrade"
