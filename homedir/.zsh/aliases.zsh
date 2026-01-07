# common cli commands
alias cd="z"
alias cdh="z ~"
alias cdw="z ~/Downloads"
alias cdr="z ~/Repos"
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
alias ping="gping -s"
alias du="dust"
alias htop="btm"
alias gtop="btm"
alias hiccup="czkawka_cli"
alias dupefs="czkawka_cli"
alias plexpermf="sudo chown -R 755"
alias plexperm="sudo chown -R plex.plex"
alias pueue="pueue -c ~/.config/pueue/pueue.yml"
alias srm="sudo ~/.cargo/bin/rip -i"
alias scat="sudo ~/.cargo/bin/bat"
alias sls="sudo ~/.cargo/bin/exa"

alias 4k2ipod="bash ~/.scripts/4k2ipod.sh"
alias musicManager="bash ~/.scripts/musicManager.sh"
alias musicSorter="bash ~/.scripts/musicSorter.sh"
alias musicSync="bash ~/.scripts/musicSync.sh"

# direct to mkntfs
alias mkntfs="/opt/homebrew/Cellar/ntfs-3g-mac/2022.10.3/sbin/mkntfs"
alias smkntfs="sudo /opt/homebrew/Cellar/ntfs-3g-mac/2022.10.3/sbin/mkntfs"

# direct to streamrip
alias streamrip="/opt/homebrew/bin/rip"

# alternative to 'cat'
alias cat="bat"

# alternative to 'find'
# alias find="fd"

# alternative to 'rm'
alias rm="rip -i"

# alternatives to 'ls'
alias ls="exa"
alias ll="exa -l"
alias la="exa -a"
alias lal="exa -al"
alias lc="find . -type f ! -name '*.sha256' ! -name '.DS_Store*' ! -name '.localized*' | wc -l"

# alternative to 'tree'
alias tree="tree-rs"

# list files
alias lf="fd . -t f -E .DS_Store"
alias lfc="fd . -t f -E .DS_Store | wc -l"
alias cls="ls -F |grep -v / | wc -l"

# search history
alias hgrep="history | ag"

# networking
alias whois="whois -h whois-servers.net"
alias netstatus="sudo $HOME/.cargo/bin/bandwhich -n"
alias dig="dog"
alias sniffnet="sudo ~/.cargo/bin/sniffnet"

# zsh
alias zconf="hx ~/.zshrc"
alias zsour="source ~/.zshrc"

# nnn
alias n="xplr"
alias nnn="xplr"

# emacs
alias emacst="emacs -nw"

# doom
alias doom="~/.emacs.d/bin/doom"

# vim
alias vi="nvim"
alias vconf="hx ~/.vimrc"
alias vsour="nvim source ~/.vimrc"

# cron
alias croe="crontab -e"
alias crol="crontab -l"

# tmux
alias tmux="tmux -2"
alias tconf="hx ~/.config/tmux/tmux.conf"

# ssh
alias rssh="sudo service ssh --full-restart"
alias stsh="sudo service ssh start"
alias spsh="sudo service ssh stop"

# Webpack
alias wpw="webpack -w"
alias wp="webpack"

# Postgres
alias psl="psql postgres -h localhost -l"

# NPM
alias nvup="npm version"
alias nr="npm run"

# nvm
alias nvi="fnm install"
alias nvu="fnm use"
alias nviu="fnm install && fnm use --delete-prefix"
alias wnv="bat -p .nvmrc"

# dev
alias start="fnm use || fnm use 16 && clear && npm run clean; npm run start"

# Git
# alias ga="git add"
alias gaa="git add --all"
alias gap="git add --patch"

alias gcm="git commit -S -m"
alias gc="git commit -S"

alias gf="git fetch"

alias gup="git push"
alias gupf="git push --force"
alias gupt="git push --tags"

alias gp="git pull --rebase"
alias gsp="git stash && git pull --rebase && git stash pop"

alias gst="git status"
alias gstat="onefetch ."

alias gai="git checkout --theirs ."
alias gao="git checkout --ours ."

# alias gdf="git diff"
alias gdfn="git diff --name-only"
alias gdfs="git diff --staged"

alias grst="git reset"
alias grsth="git reset --hard"

alias gsta="git stash"
alias gstap="git stash pop"

alias gts="git tag -s"
alias gtv="git tag | sort -V"

alias ggc="git gc --aggressive --prune"

# Docker
alias lzd="lazydocker"

# system update
alias rup="rustup update"
alias cup="cargo install-update -a"
alias bup="brew update"
alias bug="brew upgrade && brew cleanup"
alias vug="vim +PlugUpgrade +PlugUpdate +qa"
