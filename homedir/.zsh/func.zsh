zsh-defer source ${HOME}/dotfiles/lib/util/echos.sh

# MEDIA #

# search for a command in the pet database and run it
petrun() {
  local command
  command=$(pet search --color)

  if [[ -n "$command" ]]; then
    eval $command
  fi
}

# run wget inside pueue as a background job
puewget() {
  local prompt
  prompt=$(gum input --placeholder "Link") &&
  
  if [[ -n "$prompt" ]]; then
    pueue add "wget '$prompt' --no-check-certificate"
  else
    echo "No link provided."
  fi
}

# run unzip inside pueue as a background job
pueunzip() {
  local file
  IFS=$'\n' file=($(fd -t f -e 'zip' . 2>/dev/null | gum choose))
  
  if [[ -n "$file" ]]; then
    pueue add "unzip $file"
  else
    echo "No files provided."
  fi
}

# run wget with retries
forcewget() {
  local prompt
  prompt=$(gum input --placeholder "Link") &&
  
  if [[ -n "$prompt" ]]; then
    wget -v --continue --retry-on-host-error --retry-connrefused --tries=0 --no-check-certificate "$prompt"
  else
    echo "No link provided."
  fi
}

# run streamrip for Qobuz links
qobuzrip() {
  local prompt
  prompt=$(gum input --placeholder "Link") &&
  
  if [[ -n "$prompt" ]]; then
    streamrip -ndb --quality 2 url $prompt
  else
    echo "No link provided."
  fi
}

# UTILITIES #

# choose from different tmux layouts
stl() {
  local action
  action=$(gum choose "dev" "git") &&

  if [[ $action == "dev" ]]; then
    tmux new-session \; split-window -v -p 35 \;
  elif [[ $action == "git" ]]; then
    tmux new-session \; split-window -v \;
  fi
  clear;
}

# find and kill tmux sessions
fkts () {
    local sessions
    sessions="$(tmux ls | gum choose)" || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]";
            tmux kill-session -t "$match[1]"
        }
    done
}

# find and select tmux session
fst() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | gum choose ) &&

  if [[ -n $session ]]; then
    tmux a -t "$session"
  else
    echo "No session selected."
  fi
}

# find and switch tmux pane
fstp() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}

# repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf --no-sort --tac | sd ' *[0-9]*\*? *' '' | sd '\\' '\\\\')
}

# find and kill process
fkp() {
  local pid
  pid=$(ps axco pid,command,time | sed 1d | fzf --multi | mawk '{print $1}')

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
  if [[ "$OSTYPE" == "darwin"* ]]; then
    port=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
  else
    port=$(hostname -I | cut -f1 -d' ')
  fi

  echo "Checking port $port..."
  rustscan -n --top -a $port -- -A -sV
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

# glyphhanger whitelist Latin charset
gla() {
  local file fname
  IFS=$'\n' file=($(fd -t f -e 'ttf' 2>/dev/null | gum choose --no-limit))
  fname="${file%.*}" &&

  if [[ -n "$file" ]]; then
    glyphhanger --LATIN --formats=woff2,woff --subset=$file &&
    [[ -n "$fname-subset.woff" ]] && mv $fname-subset.woff $fname.woff &&
    [[ -n "$fname-subset.woff2" ]] && mv $fname-subset.woff2 $fname.woff2
  else
    echo "No files selected."
  fi
}

# select all ttf files and run glyphhanger whitelist Latin charset
agla() {
  for file in $(ls *.*tf); do
    fname="${file%.*}"
    glyphhanger --LATIN --formats=woff2,woff --subset=$file &&
    [[ -n "$fname-subset.woff" ]] && mv $fname-subset.woff $fname.woff &&
    [[ -n "$fname-subset.woff2" ]] && mv $fname-subset.woff2 $fname.woff2
  done
}

# glyphhanger whitelist US ASCII charset
glu() {
  local file fname
  IFS=$'\n' file=($(fd -t f -e 'ttf' 2>/dev/null | gum choose --no-limit))
  fname="${file%.*}" &&

  if [[ -n "$file" ]]; then
    glyphhanger --US_ASCII --formats=woff2,woff --subset=$file
  else
    echo "No files selected."
  fi
}

# select all ttf files and run glyphhanger whitelist US ASCII charset
aglu() {
  for file in $(ls *.*tf); do
    glyphhanger --US_ASCII --formats=woff2,woff --subset=$file
  done
}

# YOUTUBE #

# yt-dlp best video/audio quality
ytv() {
  local prompt
  prompt=$(gum input --placeholder "Link") &&

  if [[ -n "$prompt" ]]; then
    yt-dlp -f b --merge-output-format mp4 -o "%(title)s.%(ext)s" $prompt
  else
    echo "No link provided."
  fi
}

# yt-dlp best audio (only) quality
yta() {
  local prompt
  prompt=$(gum input --placeholder "Link") &&

  if [[ -n "$prompt" ]]; then
    yt-dlp -x --audio-format flac --audio-quality 0 $prompt
  else
    echo "No link provided."
  fi
}

# upload downloaded video to b2 archives
ytu() {
  local file
  IFS=$'\n' file=($(fd -t f -e 'ttf' -e 'mkv' 2>/dev/null | gum choose))

  if [[ -n "$file" ]]; then
    pueue add "b2 upload-file imladris $1 Bookmarks/Videos/$file"
  else
    echo "No file selected."
  fi
}

# IMAGES #

# convert PNG to WebP
png2webp() {
  fd -e png | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.png}.webp"' _ {} \;
}

# convert JPEG to WebP
jpeg2webp() {
  fd -e jpg | xargs -P 8 -I {} sh -c 'cwebp -q 90 $1 -o "${1%.jpg}.webp"' _ {} \;
}

# convert HEIC to JPEG
heic2jpeg() {
  fd -e heic | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}

# convert PNG to JPEG
png2jpeg() {
  fd -e png | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}

# convert WebP to JPEG
webp2jpeg() {
  fd -e webp | xargs -P 8 -I {} sh -c 'magick mogrify -format jpg "$1"' _ {} \;
}

# FFMPEG #

# ffmpeg clip video
clipvid() {
  local IFS file output
  IFS=$'\n' file=($(fd -t f -e 'mp4' -e 'mkv' 2>/dev/null | gum choose)) &&

  if [[ -n "$file" ]]; then
    output=$(basename $file | sd '(\.[a-z0-9]+)' '_clipped$1') &&
    ffmpeg -i $file -ss $1 -t $2 -c:v copy -c:a copy $output
  else
    echo "No file selected."
  fi
}

# extract audio from video (mp4 or mkv) and save it as mp3 with the same name
vidaudio() {
  local IFS file output
  IFS=$'\n' file=($(fd -t f -e 'mp4' -e 'mkv' 2>/dev/null | gum choose)) &&

  if [[ -n "$file" ]]; then
    output=$(basename $file | sd '(\.[a-z0-9]+)' '_audio.mp3') &&
    ffmpeg -i $file -q:a 0 -map a $output
  else
    echo "No file selected."
  fi
}

# convert video to the webM
2webm() {
  local files fname
  IFS=$'\n' files=($(fzf --query "$1" --no-multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $1 -c:v libvpx-vp9 -crf 10 -b:v 0 -b:a 128k -c:a libopus "$fname.webm"
}

# convert selected audio to aac
2aac() {
  local file fname
  IFS=$'\n' file=($(fzf --query "$1" --no-multi --select-1 --exit-0))
  fname="${file%.*}"
  [[ -n "$file" ]] && ffmpeg -i "$file" -ar 44100 -ac 2 -c:a libfdk_aac -profile:a aac_low -vbr 4 -c:v copy -disposition:v attached_pic -map '0:a' -map '0:v?' -map_metadata 0 "$fname.m4a"
}

# convert selected audio to mp4
2mp4() {
  local files fname
  IFS=$'\n' files=($(fzf --query "$1" --no-multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $files -q:v 0 "$fname.mp4"
}

# convert selected audio to mp3
2mp3() {
  local files fname
  IFS=$'\n' files=($(fzf --query "$1" --no-multi --select-1 --exit-0))
  fname="${files%.*}"
  [[ -n "$files" ]] && ffmpeg -i $files -codec:v copy -codec:a libmp3lame -q:a 2 "$fname.mp3"
}

# convert flac to alac, keeping tags and cover art
flac2alac() {
  local src dest input output
  cd / &&
  src="$(fd -t d 2>/dev/null | fzf --no-multi --select-1 --exit-0 --header "Select source directory")"
  dest="$(fd -t d 2>/dev/null | fzf --no-multi --select-1 --exit-0 --header "Select destination directory")"

  if [[ -z "$src" || -z "$dest" ]]; then
    echo "No directory selected."
    return 1
  fi

  input="/${src}"
  output="/${dest}"

  find "$input" -name "*.flac" -exec sh -c '
    input="$1"; output="$2"; file="$3"
    relpath="${file#$input}"
    outfile="${output}${relpath%.flac}.m4a"
    mkdir -p "$(dirname "$outfile")"
    ffmpeg -i "$file" -ar 44100 -c:a alac -c:v copy -map 0:a -map 0:v? -map_metadata 0 "$outfile"
  ' _ "$input" "$output" {} \; &&

  cd "$input" &&
  echo "Completed flac to alac conversion from $input to $output."
}

# convert flac to aac, keeping tags and cover art
flac2aac() {
  local src dest input output
  cd / &&
  src="$(fd -t d 2>/dev/null | fzf --no-multi --select-1 --exit-0 --header "Select source directory")"
  dest="$(fd -t d 2>/dev/null | fzf --no-multi --select-1 --exit-0 --header "Select destination directory")"

  if [[ -z "$src" || -z "$dest" ]]; then
    echo "No directory selected."
    return 1
  fi

  input="/${src}"
  output="/${dest}"

  find "$input" -name "*.flac" -exec sh -c '
    input="$1"; output="$2"; file="$3"
    relpath="${file#$input}"
    outfile="${output}${relpath%.flac}.m4a"
    mkdir -p "$(dirname "$outfile")"
    ffmpeg -i "$file" -ar 44100 -ac 2 -c:a libfdk_aac -profile:a aac_low -vbr 4 -c:v copy -disposition:v attached_pic -map '0:a' -map '0:v?' -map_metadata 0 "$outfile"
  ' _ "$input" "$output" {} \; &&

  cd "$input" &&
  echo "Completed flac to aac conversion from $input to $output."
}

# select file and retrieve the chapters using ffprobe and jq
chapters() {
  local file
  IFS=$'\n' file=($(fzf --query "$1" --no-multi --select-1 --exit-0))

  [[ -n "$file" ]] && ffprobe -v quiet -print_format json -show_format -show_chapters $file | jq -r '[.chapters[]]'
}

# 4K HDR to Wii video conversion
4k2wii() {
  local file fname escaped_file
  
  # Get file selection
  file="$(fd -t f -e 'mkv' 2>/dev/null | gum choose)"

  if [[ -z "$file" ]]; then
    echo "No file selected."
    return 1
  fi

  fname="${file:r}"  # Remove extension (zsh way)
  echo "Processing: $file"
  
  # Escape the file path for the subtitles filter
  escaped_file="${file//\\/\\\\}"
  escaped_file="${escaped_file//:/\\:}"
  escaped_file="${escaped_file//\'/\\\'}"
  
  ffmpeg -i "$file" \
    -vf "zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,scale=854:480,setsar=1,fps=30000/1001,subtitles='${escaped_file}':si=0" \
    -c:v libx264 -preset slow -crf 22 \
    -profile:v baseline -level 3.0 \
    -maxrate 2500k -bufsize 5000k \
    -x264-params "nal-hrd=cbr:force-cfr=1:keyint=60:min-keyint=60:scenecut=0" \
    -color_primaries bt709 -color_trc bt709 -colorspace bt709 \
    -c:a aac -b:a 128k -ar 48000 -ac 2 \
    -movflags +faststart \
    -vsync cfr \
    -n \
    "${fname}.mp4"
}

# 4K HDR to iPod video conversion
4k2ipod() {
  local file fname escaped_file subtitle_filter hdr
  local -a audio_args

  # Get file selection
  file="$(fd -t f -e 'mkv' 2>/dev/null | gum choose)"

  # Ask if HDR tonemapping is needed
  hdr=$(gum choose "yes" "no" --header "Is the video HDR?")

  if [[ -z "$file" ]]; then
    echo "No file selected."
    return 1
  fi

  fname="${file:r}"
  
  # Check for output file collision
  if [[ -f "${fname}.mp4" ]]; then
    echo "Error: ${fname}.mp4 already exists"
    return 1
  fi

  echo "Processing: $file"

  # Check if file has subtitles
  if ffmpeg -i "$file" 2>&1 | grep -q "Subtitle:"; then
    # Escape the file path for the subtitles filter
    escaped_file="${file//\\/\\\\}"
    escaped_file="${escaped_file//:/\\:}"
    escaped_file="${escaped_file//\'/\\\'}"
    escaped_file="${escaped_file//\[/\\[}"
    escaped_file="${escaped_file//\]/\\]}"
    subtitle_filter="subtitles='${escaped_file}':si=0,"
    echo "Burning in subtitles..."
  else
    echo "No embedded subtitles found."
    local use_external=$(gum choose "yes" "no" --header "Use external subtitle file?")
    
    if [[ $use_external == "yes" ]]; then
      local sub_file="$(fd -t f -e 'srt' -e 'ass' -e 'ssa' -e 'sub' 2>/dev/null | gum choose --header "Select subtitle file")"
      
      if [[ -n "$sub_file" ]]; then
        escaped_file="${sub_file//\\/\\\\}"
        escaped_file="${escaped_file//:/\\:}"
        escaped_file="${escaped_file//\'/\\\'}"
        escaped_file="${escaped_file//\[/\\[}"
        escaped_file="${escaped_file//\]/\\]}"
        subtitle_filter="subtitles='${escaped_file}',"
        echo "Using external subtitles: $sub_file"
      else
        subtitle_filter=""
        echo "No subtitle file selected, skipping..."
      fi
    else
      subtitle_filter=""
      echo "Skipping subtitles..."
    fi
  fi

  # Prefer libfdk_aac when available, otherwise fall back to native AAC with safer settings
  if ffmpeg -hide_banner -codecs 2>/dev/null | grep -q '\blibfdk_aac\b'; then
    audio_args=(-c:a libfdk_aac -vbr 4 -ac 2 -ar 44100 -af "aresample=resampler=soxr:osf=s16")
    echo "Encoding audio with libfdk_aac (VBR 4) using high quality resampler..."
  else
    audio_args=(-c:a aac -aac_coder twoloop -b:a 192k -ac 2 -ar 44100 -af "aresample=resampler=soxr:osf=s16")
    echo "libfdk_aac not available, using native AAC (twoloop @192k) with high quality resampler..."
  fi

  if [[ $hdr == "yes" ]]; then
    ffmpeg -i "$file" \
      -vf "${subtitle_filter}zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,scale=640:-1,pad=iw:480:0:(oh-ih)/2,format=yuv420p" \
      -vcodec libx264 -crf 23 -preset fast -profile:v baseline \
      -level 3 -refs 6 \
      "${audio_args[@]}" \
      "${fname}.mp4"
  elif [[ $hdr == "no" ]]; then
    ffmpeg -i "$file" \
      -vf "${subtitle_filter}scale=640:-1,pad=iw:480:0:(oh-ih)/2,format=yuv420p" \
      -vcodec libx264 -crf 23 -preset fast -profile:v baseline \
      -level 3 -refs 6 \
      "${audio_args[@]}" \
      "${fname}.mp4"
  fi
}

# FILES #

# render markdown files
rmd() {
  inlyne $1 --theme dark
}

# find and extract archives
fex() {
  local file fname
  IFS=$'\n' file=($(fzf --query "$1" --select-1 --exit-0))
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

# merge files to Plex directory and set proper permissions
mrgplex() {
  local src
  local dst=$2
  local dst_dir=$(dirname $dst)
  local type=$(gum choose "file" "dir" --header "Source Type")
  IFS=$'\n' src=($(fd -t $type . 2>/dev/null | gum choose --header "Source"))

  if [[ -d $dst_dir ]]; then
    if [[ -n $src ]]; then
      sudo rsync -av $src $dst &&
      sudo chown -R plex.plex "$dst/$src"
    else
      echo "No source selected."
    fi
  else
    echo "Destination directory does not exist: $dst"
  fi
}

# replace files to Plex directory and set proper permissions
rpplex() {
  local dst=$1
  local dst_dir=$(dirname $dst)
  local file
  IFS=$'\n' file=($(fd -t f . 2>/dev/null | gum choose))

  if [[ -d $dst_dir ]]; then
    yes | sudo rm "$dst/$file" &&
    sudo mv $file $dst &&
    sudo chown -R plex.plex "$dst/$file"
  else
    echo "Destination directory does not exist: $dst"
  fi
}

# replace all files to Plex directory and set proper permissions
rpplexfiles() {
  if [[ -n $1 ]]; then
    find . -type f -print0 | while IFS= read -r -d $'\0' file; do
      yes | sudo rm "$1/$file" &&
      sudo mv $file $1 &&
      sudo chown -R plex.plex "$1/$file"
    done
  else
    echo "No destination provided."
  fi
}

# move files to Plex directory and set proper permissions
mvplex() {
  local src
  local dst=$1
  local dst_dir=$(dirname $dst)
  local type=$(gum choose "file" "dir" --header "Source type")
  IFS=$'\n' src=($(fd -t $type . 2>/dev/null | gum choose --header "Source"))

  if [[ -d $dst_dir ]]; then
    if [[ -n $src ]]; then
      sudo chmod -R 755 $src;
      sudo mv $src $dst &&
      sudo chown -R plex.plex "$dst/$src"
    else
      echo "No source selected."
    fi
  else
    echo "Destination directory does not exist: $dst"
  fi
}

# move all directories to Plex directory and set proper permissions
mvplexdirs() {
  local dst=$1

  if [[ -n $1 ]]; then
    for dir in $(find * -prune -type d ); do
      sudo chmod -R 755 $dir;
      sudo mv $dir $1 &&
      sudo chown -R plex.plex "$1/$dir"
    done
  else
    echo "No destination provided."
  fi
}

# move all files to Plex directory and set proper permissions
mvplexfiles() {
  if [[ -n $1 ]]; then
    for file in $(fd -t f -e 'mkv' -e 'mp4'); do
      sudo mv $file $1 &&
      sudo chown -R plex.plex "$1/$file"
    done
  else
    echo "No destination provided."
  fi
}

# select two files, but fold lines longer than 20 characters, then diff (via delta)
diffLongSel() {
  local file1 file2
  file1=$(fzf --query "$1") &&
  file2=$(fzf --query "$1") &&
  delta <(fold -s -w 20 $file1) <(fold -s -w 20 $file2)
}

# select two files, then diff (via delta)
diffSel() {
  local file1 file2
  file1=$(fzf --query "$1") &&
  file2=$(fzf --query "$1") &&
  delta $file1 $file2
}

# open the selected file with the default editor
fe() {
  local files
  IFS=$'\n' files=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && hx ${files[@]}
}

# using ripgrep combined with preview and open on editor
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  local file line
  file="$(rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}")" &&
    line=$(rg -n $1 $file | sed -E 's/^([0-9]+).*/\1/') &&
    if [[ -n $file ]]; then
      hx $file:$line
    fi
}

# find and delete files
fdf() {
  local files
  IFS=$'\n' files=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && rm $files
}

# find and print files
fpf() {
  local files
  IFS=$'\n' files=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && echo $files
}

# find files and copy to another directory
fcf() {
  local IFS file dist
  IFS=$'\n' file=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --no-no-multi --select-1 --exit-0))
  IFS=$'\n' dist=($(fd -t d . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0))
  cp $file $dist
}

# DIRECTORIES #

# Open via rg with line number
fa() {
  local file
  local line

  read -r file line <<<"$(rg --no-heading -n $@ | fzf --exit-0 --select-1 | mawk -F: '{print $1, $2}')"

  if [[ -n $file ]]; then
    hx $file:$line
  fi
}

# find and show filepath
fsf() {
  local IFS files directory fullpath
  IFS=$'\n' files=($(fd -t d . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0))
  directory=$(dirname $files)
  fullpath="$(pwd)/$directory"
  [[ -n "$files" ]] && print $fullpath
}

# find and open file (default app)
fof() {
  local files
  IFS=$'\n' files=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0))
  [[ -n "$files" ]] && open $files
}

# fuzzy cd from anywhere
cf() {
  local file

  file="$(locate -Ai -0 $@ | rg -z -v '~$' | fzf --read0 --exit-0 --select-1)"

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
  dir=$(fd -t d --prune . ./ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
    z "$dir"
}

# cd to directory and open with selected action
fcdc() {
  local dir action
  dir=$(fd -t d . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
  action=$(gum choose "cd" "code" "nvim" "hx") &&
  z "$dir" &&
  fnm use;
  if [[ $action == "cd" ]]; then
    echo "cd $dir";
  elif [[ $action == "code" ]]; then
    code "$dir";
  elif [[ $action == "nvim" ]]; then
    nvim "$dir";
  elif [[ $action == "hx" ]]; then
    hx "$dir";
  fi
  clear &&
}

# cd to repo directory and open with selected action
fcdr() {
  local dir action
  dir=$(fd -t d --prune . ~/Repos 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
  action=$(gum choose "cd" "code" "nvim" "hx") &&
  z "$dir" &&
  fnm use;
  if [[ $action == "cd" ]]; then
    echo "cd $dir";
  elif [[ $action == "code" ]]; then
    code "$dir";
  elif [[ $action == "nvim" ]]; then
    nvim "$dir";
  elif [[ $action == "hx" ]]; then
    hx "$dir";
  fi
  git pull --rebase &&
  clear &&
}

# find file and move to another directory
ffmv() {
  local file dest
  IFS=$'\n' file=($(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0)) &&
  dest=$(fd -t d --prune . ~ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
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
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf --tac)
  z "$DIR"
}

# cd into the directory of the selected file
ffcd() {
  local file
  local dir
  file=$(fd -t f . ~/ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
  dir=$(dirname "$file") &&
  z "$dir"
}

# tree selected directory
ftr() {
  local dir
  dir=$(fd ${1:-.} -path '*/\.*' -prune \
    -o -type d -not \( -name node_modules -prune \) -print 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
    tree "$dir" -I node_modules
}

# find and delete directory
fdd() {
  local dir
  dir=$(fd -t d --prune . ./ 2>/dev/null | fzf --query "$1" --no-multi --select-1 --exit-0) &&
  rm -rf $dir
}

# GIT #

# run command on multiple repos
mg() {
  local selections
  selections=$(fd -t d --prune . ~/Repos 2>/dev/null | fzf --multi) &&

  echo "$selections" | while IFS= read -r repo; do
    echo "Running on $repo:" &&
    pushd && z "$repo" && eval "$1" && popd;
  done
}

# git log branch
glb() {
  git log --pretty=oneline --abbrev-commit origin/$1
}

# checkout git local branch
gcbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | fzf --delimiter 15) &&
    git checkout $(echo "$branch" | sd ".* " "") &&
    git pull --rebase
}

# checkout git remote branch
gcrbr() {
  git fetch
  local branches branch selectedBranch
  branches=$(git branch -r) &&
    selectedBranch=$(echo "$branches" | fzf --no-sort --exact) &&
    branch=$(echo "$selectedBranch" | sd '.*origin/([a-zA-Z0-9\.-_/]+)$' '$1')
  git checkout $branch &&
  git pull --rebase
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
    branch=$(echo "$branches" | fzf --delimiter 15) &&
    git branch -D $(echo "$branch" | sd ".* " "")
}

# merge git local branch into current
gmbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | fzf --delimiter 15) &&
    git merge -s ort $(echo "$branch" | sd ".* " "")
}

# merge squash git local branch into current
gmsbr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | fzf --delimiter 15) &&
    git merge -s ort --squash $(echo "$branch" | sd ".* " "")
}

# rebase git local branch into current
grebr() {
  local branches branch
  branches=$(git branch) &&
    branch=$(echo "$branches" | fzf --delimiter 15) &&
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
    commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact) &&
    git reset --soft $(echo "$commit" | sd ".* " "")
}

# git revert to commit
grvt() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact) &&
    git revert -n $(echo "$commit" | sd ".* " "")
}

# git checkout commit
gccm() {
  local commits commit id
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact) &&
    id=$(echo "$commit" | sd "^([a-zA-Z0-9]+)\s.*" '$1') &&
    git checkout $id
    
}

# git commit browser
gscl() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak index --bind ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (rg -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# find git commit and print selected message for new commit
gpcm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact | sd "^[a-z0-9]+\s-\s([a-zA-z\s]+).?" "$1") &&
    message="git commit -S -m \"$commit\""
  print -z $message
}

# find git commit and print details
gscm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact | sd "^([a-z0-9]+)\s-\s.*" "$1") &&
  git show $commit
}

# find git commit and show diff
gdcm() {
  local commits commit
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%N%Creset %s' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact | sd "^([a-z0-9]+)\s-\s.*" "$1") &&
  git diff $commit
}

# edit commit
gecm() {
  local commits commit id
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact) &&
    id=$(echo "$commit" | sd " .*" "")
  git rebase -i "$id^"
}

# git select commit and list all modified files since
glmf() {
  local commits commit id modFiles cleanFiles
  commits=$(git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi --tac --no-sort --exact) &&
  id=$(echo "$commit" | sd " .*" "")
  modFiles=$(git log --pretty=format:"" --name-only --abbrev-commit $id..HEAD) &&
  cleanFiles=$(echo "$modFiles" | sed '/^$/d' | sort -u) &&

  if [[ -n $cleanFiles ]]; then
    echo "$cleanFiles"
  else
    echo "No modified files found!"
  fi
}

# GITHUB CLI #

# git create new PR, add title, select reviewer
gnpr() {
  local branches selectedBranch branch reviewers handle
  users=("fourjuaneight" "davidbbaxter" "baileysh9" "bbohach")
  git fetch &&
    branches=$(git branch -r) &&
    selectedBranch=$(echo "$branches" | sd 'origin/HEAD -> .*\n' '' | sd 'origin/' '' | fzf --ansi --no-sort --exact) &&
    branch=$(echo $selectedBranch | sd '^\s*' '') &&
    handle=$(printf "%s\n" "${users[@]}" | fzf --ansi --tac --no-sort --exact) &&
    gh pr create -B $branch -t $1 -r $handle
}

# git list PRs, then inspect
gvpr() {
  git fetch
  local selectedPR PR
  selectedPR=$(gh pr list | fzf --ansi --tac --no-sort --exact) &&
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
    selectedPR=$(gh pr list | fzf --ansi --tac --no-sort --exact) &&
      PR=$(echo $selectedPR | sd '^([0-9]+).*' '$1') &&
      gh pr merge $PR -s -d
  fi
}

# NPM #

# find npm script and run
fnr() {
  local scripts
  script="$(jq -r '.scripts | keys | .[]' package.json | gum filter)"
  npm run $script
}

# version key/value should be on his own line
npv() {
  local pkg_version
  pkg_version=$(cat package.json \
    | grep version \
    | head -1 \
    | awk -F: '{ print $2 }' \
    | sed 's/[",]//g')

  echo $pkg_version
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
    selectedImage=$(echo "$images" | gum filter) &&
    image=$(echo $selectedImage | sd '^([a-z0-9]+)\s+.*' '$1') &&
    # converte list to space separate string
    imageList=$(echo $image | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
    docker image rm $imageList
}

# find and delete docker containers
dckrmcn() {
  local containers selectedContainer container containerList
  containers=$(docker container list --format "table {{.ID}}\t{{.Image}}" | sed -n '1!p') &&
    # use <TAB> to select multiple items
    selectedContainer=$(echo "$containers" | gum filter) &&
    container=$(echo $selectedContainer | sd '^([a-z0-9]+)\s+.*' '$1') &&
    # converte list to space separate string
    containerList=$(echo $container | mawk 'FNR!=1{print l}{l=$0};END{ORS="";print l}' ORS=' ') &&
    docker container rm $containerList
}

# find and build docker services
dckbd() {
  local services selectedService
  services=$(yq -M '.services | keys' docker-compose.yml | sd '\-\s' '') &&
  selectedService=$(echo "$services" | gum choose) &&

  if [[ -n $selectedService ]]; then
    clear && docker compose build $selectedService
  else
    echo "No service selected."
  fi
}

# find and start docker services
dckup() {
  local services selectedService
  services=$(yq -M '.services | keys' docker-compose.yml | sd '\-\s' '') &&
  selectedService=$(echo "$services" | gum choose) &&

  if [[ -n $selectedService ]]; then
    clear && docker compose up $selectedService
  else
    echo "No service selected."
  fi
}

# AI #

# find file and run ChatGPT query on it
mds() {
  local file prompt key
  IFS=$'\n' file=($(fzf --query "$1" --no-multi --select-1 --exit-0))
  prompt=$(gum input --placeholder "Prompt")
  key=$(op item get OpenAI --vault Personal --fields label="api key")

  if [[ -z "$file" ]]; then
    echo "No file selected!"
  elif [[ -z "$key" ]]; then
    echo "No key provided!"
  else
    export OPENAI_API_KEY=$key &&
    mods -f "$prompt" < $file | glow
  fi
}
