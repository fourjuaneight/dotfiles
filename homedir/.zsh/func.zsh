zsh-defer source ${HOME}/dotfiles/lib/util/echos.sh

# UTILITIES #

# repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | sk --no-sort --tac | sd ' *[0-9]*\*? *' '' | sd '\\' '\\\\')
}

# find and kill process
fkp() {
  local pid
  pid=$(ps axco pid,command,time | sed 1d | sk --multi | mawk '{print $1}')

  if [[ "x$pid" != "x" ]]; then
    echo $pid | xargs kill -${1:-9}
    fkp
  fi
}

# hammer a service with curl for a given number of times
curlhammer() {
  echo "curl -k -s -D - $1 -o /dev/null | rg 'HTTP/1.1' | sd 'HTTP\/1.1 ' ''"
  for i in {1..$2}; do
    curl -k -s -D - $1 -o /dev/null | rg 'HTTP/1.1' | sd 'HTTP\/1.1 ' ''
  done
}

# zsh load times
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# check for open ports
portcheck() {
  local port
  port=$(hostname -I | cut -f1 -d' ')

  echo "Checking port $port..."
  rustscan --top -a $port
}

# system dependencies and tooling updates
sysup() {
  bot "Running dependency updates."

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    minibot "updating apt dependencies"
    sudo apt-get update
    sudo apt-get upgrade -y
  fi

  minibot "updating Rust"
  rustup update

  minibot "updating Brew"
  brew update
  brew upgrade
  brew cleanup -s

  minibot "updating Cargo"
  cargo install-update -a

  minibot "updating Vim"
  vim +PlugUpgrade +PlugUpdate +qa
}

# FONTS #

# glyphhanger whitelist Latin
gla() {
  local file fname
  IFS=$'\n' file=($(sk --multi --select-1 --exit-0))
  fname="${file%.*}" &&
    if [[ -n "$file" ]]; then
      glyphhanger --LATIN --formats=woff2,woff --subset=$file &&
      [[ -n "$fname-subset.woff" ]] && mv $fname-subset.woff $fname.woff &&
      [[ -n "$fname-subset.woff2" ]] && mv $fname-subset.woff2 $fname.woff2
    fi
}

agla() {
  for file in $(ls *.*tf); do
    fname="${file%.*}"
    glyphhanger --LATIN --formats=woff2,woff --subset=$file &&
    [[ -n "$fname-subset.woff" ]] && mv $fname-subset.woff $fname.woff &&
    [[ -n "$fname-subset.woff2" ]] && mv $fname-subset.woff2 $fname.woff2
  done
}

# glyphhanger whitelist US ASCII
glu() {
  local file fname
  IFS=$'\n' file=($(sk --multi --select-1 --exit-0))
  fname="${file%.*}" &&
    if [[ -n "$file" ]]; then
      glyphhanger --US_ASCII --formats=woff2,woff --subset=$file
    fi
}

aglu() {
  for file in $(ls *.*tf); do
    glyphhanger --US_ASCII --formats=woff2,woff --subset=$file
  done
}

# YOUTUBE #

# youtube-dl best video/audio quality
ytv() {
  yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio:' --merge-output-format mp4 -o "%(title)s.%(ext)s" $1
}

# youtube-dl best audio (only) quality
yta() {
  yt-dlp -f bestaudio[ext=m4a] $1
}

# upload downloaded video to b2 archives
ytu() {
  b2 upload-file imladris $1 Bookmarks/Videos/$1
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
  fname="${files%-clipped.*}"
  ffmpeg -ss $2 -i $1 -c copy -t $3 $fname
}

2webm() {
  local files fname
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $1 -c:v libvpx-vp9 -crf 10 -b:v 0 -b:a 128k -c:a libopus "$fname.webm"
}

2acc() {
  local files fname
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $files -c:a libfdk_aac -vbr 3 -c:v copy "$fname.m4a"
}

2mp4() {
  local files fname
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $files -q:v 0 "$fname.mp4"
}

2mp3() {
  local files fname
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $files -codec:v copy -codec:a libmp3lame -q:a 2 "$fname.mp3"
}

# FILES #

# find and extract archives
fex() {
  local file fname
  IFS=$'\n' file=($(sk --query "$1" --select-1 --exit-0))
  fname="${file%.*}"

  if [ -n $file ]; then
    case $file in
    *.tar.bz2) tar -xvjf $file ;;
    *.tar.gz) tar -xvzf $file ;;
    *.bz2) bunzip2 -v $file ;;
    *.rar) unrar xv $file ;;
    *.gz) gunzip -v $file ;;
    *.tar) tar -xvf $file ;;
    *.tbz2) tar -xvjf $file ;;
    *.tgz) tar -xvzf $file ;;
    *.zip) unzip $file ;;
    *.Z) uncompress -v $file ;;
    *.7z) 7z x $file -bb ;;
    *) echo "Don't know how to extract '$file'." ;;
    esac
  else
    echo "'$file' is not a valid file!"
  fi
}

# batch rename files with regex
brn() {
  local files filesMatch
  # remove quotes
  filesMatch=$(sd '^"(.*)"$' '$1' <<<$3)
  # convert to list
  IFS=$'\n' files=($(echo $filesMatch | ls))

  for file in $files; do
    new=$(echo "$file" | sd $1 $2) &&
      echo "$file -> $new"
    mv "$file" "$new"
  done
}
brn_count() {
  local files filesMatch
  TEMPFILE=/tmp/counter.tmp
  echo "0" >$TEMPFILE

  # remove quotes
  filesMatch=$(sd '^"(.*)"$' '$1' <<<$3)
  # convert to list
  IFS=$'\n' files=($(echo $filesMatch | ls))

  for file in $files; do
    COUNTER=$(($(cat $TEMPFILE) + 1))
    echo $COUNTER >$TEMPFILE
    name=$1
    epi+="E"
    new+=$COUNTER
    echo "$file -> $new"
    mv "$file" "$new"
  done

  unlink $TEMPFILE
}

b2mkv() {
  for file in *; do
    fname="${file%.*}"
    ffmpeg -i $file -vcodec copy -acodec copy "$fname.mkv"
  done
}

# batch update mp3 title with regex
bump3t() {
  for file in $(ls *.mp3); do
    new=$(echo $file | sd $1 $2) &&
      echo "title -> $new"
    id3v2 -t "$new" $file
  done
}

# batch update mkv title from filename
bumkvt() {
  for file in $(ls *.mkv); do
    new=$(echo $file | sd "[a-zA-Z_'\-]+-S[0-9]+-E[0-9]+-(.*)\.mkv" "$1" | sd '_' ' ' | sd '-' ' - ') &&
      echo "title -> $new"
    mkvpropedit $file -e info -s title="$new"
  done
}

# batch update mkv title by chapters
bumkvc() {
  TEMPFILE=/tmp/counter.tmp
  echo $1 >$TEMPFILE

  for file in $(ls *.mkv); do
    COUNTER=$(($(cat $TEMPFILE) + 1))
    echo $COUNTER >$TEMPFILE
    echo "title -> Chapter $COUNTER"
    mkvpropedit $file -e info -s title="Chapter $new"
  done

  unlink $TEMPFILE
}

# move files to Plex directory and set proper permissions
mvplex() {
  local file=$1
  local dst=$2
  local dst_dir=$(dirname $dst)

  if [[ -d $dst_dir ]]; then
    sudo mv $file $dst
    sudo chown -R plex.plex "$dst/$file"
  else
    echo "Destination directory does not exist: $dst"
  fi
}

# rename show episode with title
rnep() {
  deno run --allow-env --allow-net --allow-read ~/.scripts/show-renamer.ts --showName=$1 --showID=$2 --season=$3
}

# select two files, but fold lines longer than 20 characters, then diff (via delta)
diffLongSel() {
  local file1 file2
  file1=$(sk --query "$1") &&
    file2=$(sk --query "$1") &&
    delta <(fold -s -w 20 $file1) <(fold -s -w 20 $file2)
}

# select two files, then diff (via delta)
diffSel() {
  local file1 file2
  file1=$(sk --query "$1") &&
    file2=$(sk --query "$1") &&
    delta $file1 $file2
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && code ${files[@]}
}

# using ripgrep combined with preview and open on VSCode
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  local file line
  file="$(rg --files-with-matches --no-messages "$1" | sk --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")" &&
    line=$(rg -n $1 $file | sed -E 's/^([0-9]+).*/\1/') &&
    if [[ -n $file ]]; then
      code -g $file:$line
    fi
}

# find and delete files
fdf() {
  local files
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && rm $files
}

# find and print files
fpf() {
  local files
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && echo $files
}

# DIRECTORIES #

# Open via rg with line number
fa() {
  local file
  local line

  read -r file line <<<"$(rg --no-heading -n $@ | sk --exit-0 --select-1 | mawk -F: '{print $1, $2}')"

  if [[ -n $file ]]; then
    code -g $file:$line
  fi
}

# find and show filepath
fsf() {
  local IFS files directory fullpath
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  directory=$(dirname $files)
  fullpath="$(pwd)/$directory"
  [[ -n "$files" ]] && open $fullpath
}

# find and open file (default app)
fof() {
  local files
  IFS=$'\n' files=($(sk --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && open $files
}

# find and open file in VSCode
fofc() {
  local out file key
  IFS=$'\n' out=($(sk --query "$1" --exit-0 --expect ctrl-o,ctrl-e))
  key=$(head -1 <<<"$out")
  file=$(head -2 <<<"$out" | tail -1)
  if [[ -n "$file" ]]; then
    [[ "$key" = ctrl-o ]] && code "$file" || ${EDITOR:-vim} "$file"
  fi
}

# fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
cf() {
  local file

  file="$(locate -Ai -0 $@ | rg -z -v '~$' | sk --read0 --exit-0 --select-1)"

  if [[ -n $file ]]; then
    if [[ -d $file ]]; then
      z -- $file
    else
      z -- ${file:h}
    fi
  fi
}

# cd to selected directory
fcd() {
  local dir
  dir=$(fd -I -E node_modules -t d --prune . ./ 2>/dev/null | sk) &&
    z "$dir"
}

# find file and move to another directory
ffmv() {
  local file dest
  IFS=$'\n' file=($(sk --query "$1" --multi --select-1 --exit-0)) &&
    dest=$(fd -I -E node_modules -t f --prune . ./ */\.* 2>/dev/null | sk) &&
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
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | sk --tac)
  z "$DIR"
}

# cd into the directory of the selected file
ffcd() {
  local file
  local dir
  file=$(sk --query "$1") &&
    dir=$(dirname "$file") &&
    z "$dir"
}

# tree selected directory
ftr() {
  local dir
  dir=$(fd ${1:-.} -path '*/\.*' -prune \
    -o -type d -not \( -name node_modules -prune \) -print 2>/dev/null | sk) &&
    tree "$dir" -I node_modules
}

# find and delete directory
fdd() {
  local dir
  dir=$(fd -I -E node_modules -t d --prune . ./ 2>/dev/null | sk) &&
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
    branch=$(echo "$branches" | sk --delimiter 15) &&
    git checkout $(echo "$branch" | sd ".* " "")
}

# checkout git remote branch
gcrbr() {
  git fetch
  local branches branch selectedBranch
  branches=$(git branch -r) &&
    selectedBranch=$(echo "$branches" | sk --no-sort --exact) &&
    branch=$(echo "$selectedBranch" | sd '.*origin/([a-zA-Z0-9\.-_/]+)$' '$1')
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
    branch=$(echo "$branches" | sk --delimiter 15) &&
    git branch -D $(echo "$branch" | sd ".* " "")
}

# merge git local branch into current
gmbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | sk --delimiter 15) &&
    git merge -s ort $(echo "$branch" | sd ".* " "")
}

# merge squash git local branch into current
gmsbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | sk --delimiter 15) &&
    git merge -s ort --squash $(echo "$branch" | sd ".* " "")
}

# rebase git local branch into current
grebr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | sk --delimiter 15) &&
    git rebase $(echo "$branch" | sd ".* " "")
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
    commit=$(echo "$commits" | sk --ansi --tac --no-sort --exact) &&
    git reset --soft $(echo "$commit" | sd ".* " "")
}

# git revert to commit
grvt() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | sk --ansi --tac --no-sort --exact) &&
    git revert $(echo "$commit" | sd ".* " "")
}

# git commit browser
gscl() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    sk --ansi --no-sort --reverse --tiebreak index --bind ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (rg -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# find git commit and print selected message for new commit
fgcm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | sk --ansi --tac --no-sort --exact | sd "^[a-z0-9]+\s-\s([a-zA-z\s]+).?" "$1") &&
    message="git commit -S -m \"$commit\""
  print -z $message
}

# edit commit
gec() {
  local commits commit id
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | sk --ansi --tac --no-sort --exact) &&
    id=$(echo "$commit" | sd " .*" "")
  git rebase -i "$id^"
}

# GITHUB CLI #

# git create new PR, add title, select reviewer
gnpr() {
  local branches selectedBranch branch reviewers handle
  users=("fourjuaneight" "davidbbaxter" "baileysh9" "bbohach")
  git fetch &&
    branches=$(git branch -r) &&
    selectedBranch=$(echo "$branches" | sd 'origin/HEAD -> .*\n' '' | sd 'origin/' '' | sk --ansi --no-sort --exact) &&
    branch=$(echo $selectedBranch | sd '^\s*' '') &&
    handle=$(printf "%s\n" "${users[@]}" | sk --ansi --tac --no-sort --exact) &&
    gh pr create -B $branch -t $1 -r $handle
}

# git list PRs, then inspect
gvpr() {
  git fetch
  local selectedPR PR
  selectedPR=$(gh pr list | sk --ansi --tac --no-sort --exact) &&
    PR=$(echo $selectedPR | sd '^([0-9]+).*' '$1') &&
    gh pr view $PR
}

# git merge (squash and delete branch) PR. Provide number or select from open PRs
gmpr() {
  git fetch
  local selectedPR PR
  if [[ "$1" ]]; then
    gh pr merge $1 -s
  else
    selectedPR=$(gh pr list | sk --ansi --tac --no-sort --exact) &&
      PR=$(echo $selectedPR | sd '^([0-9]+).*' '$1') &&
      gh pr merge $PR -s -d
  fi
}

# DOCKER #

# delete all containers and images
dckclean() {
  local dangling
  docker system df &&
    docker system prune -a -f &&
    dangling=$(docker volume ls -qf dangling=true)
  if [[ "$dangling" ]]; then
    docker volume rm "$dangling"
  fi
}

# find and delete docker images
dckrmim() {
  local images selectedImage image imageList
  images=$(docker image list --format "table {{.ID}}\t{{.Repository}}" | sed -n '1!p') &&
    # use <TAB> to select multiple items
    selectedImage=$(echo "$images" | sk --no-sort --multi --exact) &&
    image=$(echo $selectedImage | sd '^([a-z0-9]+)\s+.*' '$1') &&
    # converte list to space separate string
    imageList=$(echo $image | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
    docker image rm $imageList
}

# find and delete docker containers
dckrmcn() {
  local containers selectedContainer container containerList
  containers=$(docker container list --format "table {{.ID}}\t{{.Repository}}" | sed -n '1!p') &&
    # use <TAB> to select multiple items
    selectedContainer=$(echo "$containers" | sk --no-sort --multi --exact) &&
    container=$(echo $selectedContainer | sd '^([a-z0-9]+)\s+.*' '$1') &&
    # converte list to space separate string
    containerList=$(echo $container | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
    docker container rm $containerList
}

# find and start docker services
dckup() {
  local services selectedService
  services=$(docker-compose ps --services) &&
    selectedService=$(echo "$services" | sk --no-sort --exact) &&
    clear && docker compose up $selectedService
}
