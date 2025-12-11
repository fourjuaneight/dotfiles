#!/bin/bash

# This script manages music files with the following functionalities:
# - Checking for latest files in a music directory. Modified files within the last 1 hour are listed.
# - Convert FLAC files to ALAC and AAC format while preserving tags and cover art.
# - Only processes files that haven't been converted yet (checks for existing output).

set -euo pipefail

MUSIC_DIR="/Volumes/Sergio"
FLAC_DIR="$MUSIC_DIR/Music"
ALAC_DIR="$MUSIC_DIR/iTunes"
AAC_DIR="/Volumes/Sandro/iPod"
LOG_FILE="$HOME/.scripts/music_manager.log"
PARALLEL_JOBS=4

# Logging helper
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if required directories exist
if [[ ! -d "$FLAC_DIR" ]]; then
    log "ERROR: Source directory $FLAC_DIR does not exist."
    exit 1
fi

# Step 1: Check for latest files
log "Checking for recently modified FLAC files in $FLAC_DIR..."
RECENT_FILES=$(find "$FLAC_DIR" -type f -name "*.flac" -mmin -60 2>/dev/null || true)

if [[ -n "$RECENT_FILES" ]]; then
    log "Recently modified FLAC files (within the last hour):"
    echo "$RECENT_FILES" | tee -a "$LOG_FILE"
else
    log "No FLAC files have been modified in the last hour."
fi

# Convert single file to ALAC
convert_to_alac() {
    local file="$1"
    local relpath="${file#"$FLAC_DIR"}"
    local outfile="$ALAC_DIR/${relpath%.flac}.m4a"

    # Skip if output already exists and is newer than input
    if [[ -f "$outfile" && "$outfile" -nt "$file" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$outfile")"
    if ffmpeg -n -loglevel warning -i "$file" -ar 44100 -c:a alac -c:v copy -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1; then
        echo "Converted to ALAC: $relpath"
    else
        echo "ERROR: Failed to convert to ALAC: $relpath" >&2
        return 1
    fi
}

# Convert single file to AAC
convert_to_aac() {
    local file="$1"
    local relpath="${file#"$FLAC_DIR"}"
    local outfile="$AAC_DIR/${relpath%.flac}.m4a"

    # Skip if output already exists and is newer than input
    if [[ -f "$outfile" && "$outfile" -nt "$file" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$outfile")"
    if ffmpeg -n -loglevel warning -i "$file" -ar 44100 -ac 2 -c:a libfdk_aac -profile:a aac_low -vbr 4 -c:v copy -disposition:v attached_pic -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1; then
        echo "Converted to AAC: $relpath"
    else
        echo "ERROR: Failed to convert to AAC: $relpath" >&2
        return 1
    fi
}

export -f convert_to_alac convert_to_aac
export FLAC_DIR ALAC_DIR AAC_DIR

# Step 2: Convert FLAC to ALAC
log "Converting FLAC files to ALAC format..."
if [[ -d "$ALAC_DIR" ]] || mkdir -p "$ALAC_DIR"; then
    find "$FLAC_DIR" -type f -name "*.flac" -print0 | \
        xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'convert_to_alac "$@"' _ {}
    log "FLAC to ALAC conversion completed."
else
    log "ERROR: Cannot create ALAC output directory $ALAC_DIR"
fi

# Step 3: Convert FLAC to AAC
log "Converting FLAC files to AAC format..."
if [[ -d "$AAC_DIR" ]] || mkdir -p "$AAC_DIR"; then
    find "$FLAC_DIR" -type f -name "*.flac" -print0 | \
        xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'convert_to_aac "$@"' _ {}
    log "FLAC to AAC conversion completed."
else
    log "ERROR: Cannot create AAC output directory $AAC_DIR"
fi

log "Music management tasks completed."