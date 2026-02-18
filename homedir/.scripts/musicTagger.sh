#!/bin/bash

# This script reads music files from OUTPUT_DIR and lists them nested album directories, then prompts the user to select an album to tag.
# 1. List ALBUMS in OUTPUT_DIR
# 2. Prompt user to select an album
# 3. Ask the tag value to update GENRE only
# 4. Update the GENRE tag for all files in the selected album directory

set -euo pipefail

# Enable extended glob patterns used for filename normalization.
shopt -s extglob

MUSIC_DIR="$HOME/StreamripDownloads"
# dir structure: OUTPUT/Artist/Album/*.flac
OUTPUT_DIR="$MUSIC_DIR/OUTPUT"
LOG_FILE="$HOME/.scripts/logs/music_tagger.log"

# ensure log directory exists (tee will fail under set -e otherwise)
mkdir -p "$(dirname "$LOG_FILE")"

# Check whether a command exists in PATH.
# Usage: require_cmd <command>
# Returns: 0 if found, 1 if not.
require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Append a timestamped log line to stdout and the log file.
# Usage: log "message"
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

safe_mkdir() {
  mkdir -p "$1"
}

is_album_with_flac() {
  local album_dir="$1"
  [[ -n "$(find "$album_dir" -type f \( -iname "*.flac" \) -print -quit)" ]]
}

main() {
  if [[ ! -d "$OUTPUT_DIR" ]]; then
    log "ERROR: OUTPUT_DIR does not exist: $OUTPUT_DIR"
    exit 1
  fi

  if ! require_cmd metaflac; then
    log "ERROR: metaflac is required but not installed"
    log "Install FLAC tools and try again"
    exit 1
  fi

  safe_mkdir "$(dirname "$LOG_FILE")"

  album_dirs=()
  while IFS= read -r dir; do
    if is_album_with_flac "$dir"; then
      album_dirs+=("$dir")
    fi
  done < <(find "$OUTPUT_DIR" -mindepth 2 -maxdepth 2 -type d | sort)

  if [[ ${#album_dirs[@]} -eq 0 ]]; then
    log "No album directories with FLAC files found in: $OUTPUT_DIR"
    exit 0
  fi

  log "Albums found in: $OUTPUT_DIR"
  for i in "${!album_dirs[@]}"; do
    rel_path="${album_dirs[$i]#"$OUTPUT_DIR"/}"
    printf "%2d) %s\n" "$((i + 1))" "$rel_path"
  done

  selection=""
  while true; do
    read -r -p "Select album number to tag (1-${#album_dirs[@]}): " selection

    if [[ "$selection" =~ ^[0-9]+$ ]] && (( selection >= 1 && selection <= ${#album_dirs[@]} )); then
      break
    fi

    log "WARN: Invalid selection. Expected a number between 1 and ${#album_dirs[@]}"
  done

  selected_album="${album_dirs[$((selection - 1))]}"
  log "Selected album: ${selected_album#"$OUTPUT_DIR"/}"

  genre=""
  while [[ -z "$genre" ]]; do
    read -r -p "Enter new GENRE value: " genre
    genre="${genre##+([[:space:]])}"
    genre="${genre%%+([[:space:]])}"

    if [[ -z "$genre" ]]; then
      log "WARN: GENRE cannot be empty"
    fi
  done

  log "Applying GENRE tag: $genre"

  updated=0
  failed=0
  while IFS= read -r file; do
    if metaflac --remove-tag=GENRE --set-tag="GENRE=$genre" "$file"; then
      updated=$((updated + 1))
    else
      failed=$((failed + 1))
      log "WARN: Failed to update GENRE for file: $file"
    fi
  done < <(find "$selected_album" -type f -iname "*.flac" | sort)

  if [[ "$updated" -eq 0 && "$failed" -gt 0 ]]; then
    log "ERROR: No files were updated. Failed on $failed file(s) in: ${selected_album#"$OUTPUT_DIR"/}"
    exit 1
  fi

  if [[ "$failed" -gt 0 ]]; then
    log "Done with warnings: updated $updated file(s), failed $failed file(s) in: ${selected_album#"$OUTPUT_DIR"/}"
  else
    log "Done: updated GENRE for $updated file(s) in: ${selected_album#"$OUTPUT_DIR"/}"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi