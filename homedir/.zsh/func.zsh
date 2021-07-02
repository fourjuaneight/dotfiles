source ${HOME}/dotfiles/lib/util/echos.sh

# UTILITIES #

# repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
}

# find and extract archives
fex() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  fname="${files%.*}";
  if [ -n $files ] ; then
    case $files in
      *.tar.bz2)  tar xvjf $files   ;;
      *.tar.gz)   tar xvzf $files   ;;
      *.bz2)      bunzip2 $files    ;;
      *.rar)      unrar x $files    ;;
      *.gz)       gunzip $files     ;;
      *.tar)      tar xvf $files    ;;
      *.tbz2)     tar xvjf $files   ;;
      *.tgz)      tar xvzf $files   ;;
      *.zip)      unzip $files      ;;
      *.Z)        uncompress $files ;;
      *.7z)       7z x $files       ;;
      *)          echo "don't know how to extract '$files'..." ;;
    esac
  else
    echo "'$files' is not a valid file!"
  fi
}

# find and kill process
fkp() {
  local pid
  pid=$(ps axco pid,command,time | sed 1d | fzf -m | mawk '{print $1}')

  if [[ "x$pid" != "x" ]];
  then
    echo $pid | xargs kill -${1:-9}
    fkp
  fi
}

# hammer a service with curl for a given number of times
curlhammer () {
  echo "curl -k -s -D - $1 -o /dev/null | rga 'HTTP/1.1' | sed 's/HTTP\/1.1 //'"
  for i in {1..$2}
  do
    curl -k -s -D - $1 -o /dev/null | rga 'HTTP/1.1' | sed 's/HTTP\/1.1 //'
  done
}

# zsh load times
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# system dependencies and tooling updates
sysup() {
  bot "Running dependency updates."

  minibot "updating Rust"
  rustup update

  minibot "updating Brew"
  brew update
  brew upgrade
  brew cleanup -s

  minibot "updating Cargo"
  cargo install-update -a

  bot "Running tooling updates."

  minibot "updating Vim"
  vim +PlugUpgrade +PlugUpdate +qa
}

# FONTS #

# glyphhanger whitelist Latin
gla() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1.ttf" --multi --select-1 --exit-0))
  fname="${files%.*}" &&
  if [[ -n "$files" ]]; then
    glyphhanger --LATIN --formats=woff2,woff --subset=$fname.ttf &&
    [[ -n "$fname-subset.woff" ]] && mv $fname-subset.woff $fname.woff &&
    [[ -n "$fname-subset.woff2" ]] && mv $fname-subset.woff2 $fname.woff2
  fi
}

# glyphhanger whitelist US ASCII
glu() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1.ttf" --multi --select-1 --exit-0))
  fname="${files%.*}" &&
  if [[ -n "$files" ]]; then
    glyphhanger --US_ASCII --formats=woff2,woff --subset=$fname.ttf
  fi
}


# YOUTUBE #

# youtube-dl beat video/audio quality
ytv() {
  youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio:' --merge-output-format mp4 -o "%(title)s.%(ext)s" $1
}

# youtube-dl beat audio (only) quality
yta() {
  youtube-dl -f bestaudio[ext=m4a] $1
}


# IMAGES #

# converting PNG to WebP
png2webp() {
  fd -e png | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.png}.webp"' _ {} \;
}

# converting JPEG to WebP
jpeg2webp() {
  fd -e jpg | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.jpg}.webp"' _ {} \;
}

# converting HEIC to JPEG
heic2jpeg() {
  fd -e heic | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}

# converting PNG to JPEG
png2jpeg() {
  fd -e png | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}

# converting WebP to JPEG
webp2jpeg() {
  fd -e webp | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}


# FFMPEG #

# ffmpeg clip video
# 1 - input file
# 2 - start time
# 3 - stop time
clipvid() {
  fname="${files%-clipped.*}";
  ffmpeg -ss $2 -i $1 -c copy -t $3 $fname;
}

2webm() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && ffmpeg -i $1 -c:v libvpx-vp9 -crf 10 -b:v 0 -b:a 128k -c:a libopus "$fname.webm";
}

2acc() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && ffmpeg -i $files -c:a libfdk_aac -vbr 3 -c:v copy "$fname.m4a";
}

2mp4() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && ffmpeg -i $files -q:v 0 "$fname.mp4";
}

2mp3() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && ffmpeg -i $files -codec:v copy -codec:a libmp3lame -q:a 2 "$fname.mp3";
}


# FILES #
# select two files, but fold lines longer than 20 characters, then diff (via delta)
diffLongSel() {
  local file1 file2
  file1=$(fzf +m -q "$1") &&
  file2=$(fzf +m -q "$1") &&
  delta <(fold -s -w 20 $file1) <(fold -s -w 20 $file2)
}

# select two files, then diff (via delta)
diffSel() {
  local file1 file2
  file1=$(fzf +m -q "$1") &&
  file2=$(fzf +m -q "$1") &&
  delta $file1 $file2
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && code ${files[@]}
}

# using ripgrep combined with preview and open on VSCode
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  local file line
  file="$(rga --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rga --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rga --ignore-case --pretty --context 10 '$1' {}")" &&
  line=$(rga -n $1 $file | gsed -r "s/^([[:digit:]]+)\:\s\s.*/\1/") &&

  if [[ -n $file ]]
  then
    code -g $file:$line
  fi
}

# find and delete files
fdf() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && rm $files
}

# DIRECTORIES #

# Open via rga with line number
fa() {
  local file
  local line

  read -r file line <<<"$(rga --no-heading -n $@ | fzf -0 -1 | mawk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
    code -g $file:$line
  fi
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [[ -n "$file" ]]; then
    [[ "$key" = ctrl-o ]] && code "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
cf() {
  local file

  file="$(locate -Ai -0 $@ | rga -z -v '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        z -- $file
     else
        z -- ${file:h}
     fi
  fi
}

# cd to selected directory
fcd() {
  local dir
  dir=$(fd -I -E node_modules -t d --prune . ./ 2> /dev/null | fzf +m) &&
  z "$dir"
}

# find file and move to another directory
ffmv() {
  local file dest
  IFS=$'\n' file=($(fzf-tmux --query="$1" --multi --select-1 --exit-0)) &&
  dest=$(fd -I -E node_modules -t f --prune . ./ */\.* 2> /dev/null | fzf +m) &&
  mv "$file" "$dest"
}

# cd to selected parent directory
fpcd() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  z "$DIR"
}

# cd into the directory of the selected file
ffcd() {
   local file
   local dir
   file=$(fzf +m -q "$1") &&
   dir=$(dirname "$file") &&
   z "$dir"
}

# tree selected directory
ftr() {
  local dir
  dir=$(fd ${1:-.} -path '*/\.*' -prune \
                  -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) &&
  tree "$dir" -I node_modules
}

# find and delete directory
fdd() {
  local dir
  dir=$(fd -I -E node_modules -t d --prune . ./ 2> /dev/null | fzf +m) &&
  rm -rf $dir
}


# GIT #

# git log branch
glb() {
  git log --pretty=oneline --abbrev-commit origin/$1
}

# checkout git local branch
gcbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# checkout git remote branch
gcrbr() {
  git fetch
  local branches branch selectedBranch
  branches=$(git branch -r) &&
  selectedBranch=$(echo "$branches" | fzf +s +m -e) &&
  branch=$(echo "$selectedBranch" | sed "s:.* origin/::" | sed "s:.* ::")
  git checkout $branch
}

# create git branch and add to remote
gnbr() {
  git fetch
  git checkout -b $1
  git push -u
}

# delete git local branch
gdbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git branch -D $(echo "$branch" | sed "s/.* //")
}

# merge git local branch into current
gmbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git merge $(echo "$branch" | sed "s/.* //")
}

# rebase git local branch into current
grebr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git rebase $(echo "$branch" | sed "s/.* //")
}

# git pull rebase given branch
gpr() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}

# git reset soft to commit id
grs() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git reset --soft $(echo "$commit" | sed "s/ .*//")
}

# git reset hard to commit id
grh() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git reset --hard $(echo "$commit" | sed "s/ .*//")
}

# git revert to commit
grvt() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git revert $(echo "$commit" | sed "s/ .*//")
}

# git commit browser
gscl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (rga -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# find git commit and print selected message for new commit
fgcm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e | gsed -r "s/^[a-z0-9]+\s-\s([a-zA-z\s]+).?/\1/g") &&
  message="git commit -S -m \"$commit\""
  print -z $message
}

# edit commit
gec() {
  local commits commit id
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  id=$(echo "$commit" | sed "s/ .*//")
  git rebase -i "$id^"
}

# GITHUB CLI #

# git create new PR, add title, select reviewer
gnpr() {
  git fetch
  local branches selectedBranch branch reviewers handle
  branches=$(git branch -r) &&
  selectedBranch=$(echo "$branches" | sed 's/origin\///g' | fzf --ansi +s +m -e) &&
  branch=$(echo $selectedBranch | sed 's/^[[:space:]]*//g') &&
  reviewers=(fourjuaneight nathSierra jfbloom22) &&
  handle=$(print -l "${(@)reviewers}" | fzf --ansi --tac +s +m -e) &&
  gh pr create -B $branch -t $1 -r $handle
}

# git list PRs, then inspect
gvpr() {
  git fetch
  local selectedPR PR
  selectedPR=$(gh pr list | fzf --ansi --tac +s +m -e) &&
  PR=$(echo $selectedPR | sed -E 's/^([[:digit:]]+).*/\1/g') &&
  gh pr view $PR
}

# git merge PR. Provide number or select from open PRs
gmpr() {
  git fetch
  local selectedPR PR
  if [[ "$1" ]]; then
    gh pr merge $1 -s
  else
    selectedPR=$(gh pr list | fzf --ansi --tac +s +m -e) &&
    PR=$(echo $selectedPR | sed -E 's/^([[:digit:]]+).*/\1/g') &&
    gh pr merge $PR -s
  fi
}


# DOCKER #

# find and delete docker images
dckrmim() {
  local images selectedImage image imageList
  images=$(docker image list --format "table {{.ID}}\t{{.Repository}}" | sed -n '1!p') &&
  # use <TAB> to select multiple items
  selectedImage=$(echo "$images" | fzf +s -m -e) &&
  image=$(echo $selectedImage | sed -E 's/^([a-z0-9]+)[[:space:]]+.*/\1/g') &&
  # converte list to space separate string
  imageList=$(echo $image | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
  docker image rm $imageList
}

# find and delete docker containers
dckrmcn() {
  local containers selectedContainer container containerList
  containers=$(docker container list --format "table {{.ID}}\t{{.Repository}}" | sed -n '1!p') &&
  # use <TAB> to select multiple items
  selectedContainer=$(echo "$containers" | fzf +s -m -e) &&
  container=$(echo $selectedContainer | sed -E 's/^([a-z0-9]+)[[:space:]]+.*/\1/g') &&
  # converte list to space separate string
  containerList=$(echo $container | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
  docker container rm $containerList
}

# find and start docker services
dckup() {
  local services selectedService
  services=$(docker-compose ps --services) &&
  selectedService=$(echo "$services" | fzf +s -e) &&
  clear && docker compose up $selectedService
}
