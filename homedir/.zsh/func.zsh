# UTILITIES #

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
}

# fex - find and extract archives
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
      *.7z)       7z x $files    ;;
      *)          echo "don't know how to extract '$files'..." ;;
    esac
  else
    echo "'$files' is not a valid file!"
  fi
}

# fkill - find and kill process
fkl() {
  local pid
  pid=$(ps axco pid,command | sed 1d | fzf -m | mawk '{print $1}')

  if [[ "x$pid" != "x" ]];
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

## hammer a service with curl for a given number of times
curlhammer () {
  echo "curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'"
  for i in {1..$2}
  do
    curl -k -s -D - $1 -o /dev/null | grep 'HTTP/1.1' | sed 's/HTTP\/1.1 //'
  done
}

# FONTS #

# gla - glyphhanger whitelist Latin
gla() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1.ttf" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && glyphhanger --LATIN --formats=woff2,woff --subset=$fname.ttf
}

# glu - glyphhanger whitelist US ASCII
glu() {
  local files fname
  IFS=$'\n' files=($(fzf-tmux --query="$1.ttf" --multi --select-1 --exit-0))
  fname="${files%.*}";
  [[ -n "$files" ]] && glyphhanger --US_ASCII --formats=woff2,woff --subset=$fname.ttf
}


# YOUTUBE #

# ytv - youtube-dl beat video/audio quality
ytv() {
  youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio:' --merge-output-format mp4 -o "%(title)s.%(ext)s" $1
}

# yta - youtube-dl beat audio (only) quality
yta() {
  youtube-dl -f bestaudio[ext=m4a] $1
}


# IMAGES #

# webp - converting PNGs to webp
wbpng() {
  fd -e png | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.png}.webp"' _ {} \;
}

# webp - converting JPEGs to webp
wbjpg() {
  find -e jpg | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.jpg}.webp"' _ {} \;
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
  [[ -n "$files" ]] && ffmpeg -i $files -acodec libmp3lame "$fname.mp3";
}


# TMUX #

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [[ $1 ]]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
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
  file="$(rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")" &&
  line=$(rg -n $1 $file | gsed -r "s/^([[:digit:]]+)\:\s\s.*/\1/") &&

  if [[ -n $file ]]
  then
    code -g $file:$line
  fi
}

# fdf - find and delete files
fdf() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && rm $files
}

# DIRECTORIES #

# fa - Open via ag with line number
fa() {
  local file
  local line

  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | mawk -F: '{print $1, $2}')"

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

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
cf() {
  local file

  file="$(locate -Ai -0 $@ | ag -z -v '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

# fcd - cd to selected directory
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# ffmv - find file and move to another directory
ffmv() {
  local file dest
  IFS=$'\n' file=($(fzf-tmux --query="$1" --multi --select-1 --exit-0)) &&
  dest=$(find ~ -path '*/\.*' -prune \
                  -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) &&
  mv "$file" "$dest"
}

# fpcd - cd to selected parent directory
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
  cd "$DIR"
}

# ffcd - cd into the directory of the selected file
ffcd() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# ftr - tree selected directory
ftr() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) &&
  tree "$dir" -I node_modules
}

# fdd - find and delete directory
fdd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -not \( -name node_modules -prune \) -print 2> /dev/null | fzf +m) &&
  rm -rf $dir
}


# GIT #

# git log branch
# (G)it(L)og(B)ranch
glb() {
  git log --pretty=oneline --abbrev-commit origin/$1
}

# checkout git local branch
# (G)it(C)heckout(B)(R)anch
gcbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# checkout git remote branch
# (G)it(C)heckout(R)emote(B)(R)anch
gcrbr() {
  git fetch
  local branches branch
  branches=$(git branch -r) &&
  branch=$(echo "$branches" | fzf +s +m -e) &&
  git checkout $(echo "$branch" | sed "s:.* remotes/origin/::" | sed "s:.* ::")
}

# create git branch and add to remote
# (G)it(N)ew(B)(R)anch <NEW-BRANCH-NAME>
gnbr() {
  git fetch
  git checkout -b $1
  git push -u
}

# delete git local branch
# (G)it(D)elete(B)(R)anch
gdbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git branch -D $(echo "$branch" | sed "s/.* //")
}

# merge git local branch into current
# (G)it(M)erge(B)(R)anch
gmbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git merge $(echo "$branch" | sed "s/.* //")
}

# rebase git local branch into current
# (G)it(R)(E)base(B)(R)anch
grebr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
  git rebase $(echo "$branch" | sed "s/.* //")
}

# git pull rebase given branch
# (G)it(P)ull(R)ebase
gpr() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}

# git reset soft to commit id
# (G)it(R)eset(S)oft
grs() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git reset --soft $(echo "$commit" | sed "s/ .*//")
}

# git reset hard to commit id
# (G)it(R)eset(H)ard
grh() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git reset --hard $(echo "$commit" | sed "s/ .*//")
}

# git revert to commit
# (G)it(R)e(V)er(T)
grvt() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e) &&
  git revert $(echo "$commit" | sed "s/ .*//")
}

# fshow - git commit browser
# (G)it(S)how(C)commit(L)og
gscl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fgcm - find git commit and price selected message for new commit
fgcm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac +s +m -e | gsed -r "s/^[a-z0-9]+\s-\s([a-zA-z\s]+).?/\1/g") &&
  message="git commit -S -m \"$commit\""
  print -z $message
}

# Emacs Diff
ediff() {
  emacs --eval "(ediff-files \"$1\" \"$2\")";
}

# GITHUB CLI #

# git create pr, add title, select reviewer
# (G)it(C)reate(P)(R)
gcpr() {
  git fetch
  local branches selectedBranch branch reviewers handle
  branches=$(git branch -r) &&
  selectedBranch=$(echo "$branches" | sed 's/origin\///g' | fzf +s +m -e) &&
  branch=$(echo $selectedBranch | sed 's/^[[:space:]]*//g') &&
  reviewers=(fourjuaneight nathSierra jfbloom22) &&
  handle=$(print -l "${(@)reviewers}" | fzf --ansi --tac +s +m -e) &&
  gh pr create -B $branch -t $1 -r $handle
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
  containers=$(docker image list --format "table {{.ID}}\t{{.Repository}}" | sed -n '1!p') &&
  # use <TAB> to select multiple items
  selectedContainer=$(echo "$containers" | fzf +s -m -e) &&
  container=$(echo $selectedContainer | sed -E 's/^([a-z0-9]+)[[:space:]]+.*/\1/g') &&
  # converte list to space separate string
  containerList=$(echo $container | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
  docker container rm $containerList
}
