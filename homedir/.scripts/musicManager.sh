#!/bin/bash

# This script manages music files with the following functionalities:
# - Checking for latest files in a music directory. Modified files within the last 1 hour are listed.
# - Convert FLAC files to ALAC and AAC format while preserving tags and cover art.
# - Only processes files that haven't been converted yet (checks for existing output).

set -euo pipefail

MUSIC_DIR="$HOME/StreamripDownloads"
OUTPUT_DIR="$MUSIC_DIR/OUTPUT"
P_DRIVE="/Volumes/Sergio"
S_DRIVE="/Volumes/Sandro"
FLAC_DIR="$P_DRIVE/Music"
ALAC_DIR="$S_DRIVE/Music/ALAC"
AAC_DIR="$S_DRIVE/Music/AAC"
LOG_FILE="$HOME/.scripts/logs/music_manager.log"
PARALLEL_JOBS=4
RECENT_MINS=60

# Ensure log directory exists (tee will fail under set -e otherwise)
mkdir -p "$(dirname "$LOG_FILE")"

require_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Logging helper
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Check if required directories exist
if [[ ! -d "$FLAC_DIR" ]]; then
    log "ERROR: Source directory $FLAC_DIR does not exist."
    exit 1
fi

if ! require_cmd ffmpeg; then
    log "ERROR: ffmpeg not found in PATH."
    exit 1
fi

# Determine which AAC encoder to use.
# Homebrew ffmpeg often lacks libfdk_aac; fall back to the built-in "aac" encoder.
# ffmpeg prints capability flags between the leading "A" and the encoder name (e.g. "A....D libfdk_aac").
AAC_ENCODER="aac"
if ffmpeg -hide_banner -encoders 2>/dev/null | grep -qE '^[[:space:]]*A[[:alnum:].]*[[:space:]]+libfdk_aac([[:space:]]|$)'; then
    AAC_ENCODER="libfdk_aac"
fi
log "AAC encoder selected: $AAC_ENCODER"

if [[ "$PARALLEL_JOBS" -lt 1 ]]; then
    log "ERROR: PARALLEL_JOBS must be >= 1 (got $PARALLEL_JOBS)."
    exit 1
fi

# Step 1: Move new music from OUTPUT_DIR to FLAC_DIR
log "Checking for new music directories in $OUTPUT_DIR..."
if [[ -d "$OUTPUT_DIR" ]]; then
    # Find all top-level directories in OUTPUT_DIR
    shopt -s nullglob
    OUTPUT_DIRS=("$OUTPUT_DIR"/*/)
    shopt -u nullglob

    if [[ ${#OUTPUT_DIRS[@]} -gt 0 ]]; then
        for dir in "${OUTPUT_DIRS[@]}"; do
            dir_name="$(basename "$dir")"
            dest_dir="$FLAC_DIR/$dir_name"

            if [[ -d "$dest_dir" ]]; then
                # Directory exists in FLAC_DIR, merge contents using rsync
                log "Merging '$dir_name' into existing directory at $dest_dir..."
                # Strip trailing slash to ensure rsync copies the directory itself, not just its contents
                if rsync -av --remove-source-files "${dir%/}" "$FLAC_DIR/" 2>&1 | tee -a "$LOG_FILE"; then
                    # Remove empty source directory after rsync
                    find "$dir" -type d -empty -delete 2>/dev/null || true
                    log "Merged: $dir_name"
                else
                    log "ERROR: Failed to merge directory: $dir_name"
                fi
            else
                # Directory doesn't exist, simply move it
                log "Moving '$dir_name' to $FLAC_DIR..."
                if mv "$dir" "$FLAC_DIR/" 2>&1 | tee -a "$LOG_FILE"; then
                    log "Moved: $dir_name"
                else
                    log "ERROR: Failed to move directory: $dir_name"
                fi
            fi
        done
        log "Music directory migration completed."
    else
        log "No directories found in $OUTPUT_DIR to move."
    fi
else
    log "WARNING: OUTPUT_DIR ($OUTPUT_DIR) does not exist. Skipping migration step."
fi

# Step 2: Check for latest files
log "Checking for recently modified FLAC files in $FLAC_DIR..."
# Store as an array to avoid word-splitting issues and to work safely with `set -u`.
# Use -print0 + read -d '' for correct handling of spaces/newlines in filenames.
RECENT_FILES=()
while IFS= read -r -d '' f; do
    RECENT_FILES+=("$f")
done < <(find "$FLAC_DIR" -type f -name "*.flac" -mmin "-$RECENT_MINS" -print0 2>/dev/null || true)

if [[ ${#RECENT_FILES[@]} -gt 0 ]]; then
    log "Recently modified FLAC files (within the last ${RECENT_MINS} minutes):"
    printf '%s\n' "${RECENT_FILES[@]}" | tee -a "$LOG_FILE"
else
    log "No FLAC files have been modified in the last ${RECENT_MINS} minutes."
fi

# Convert one FLAC file to ALAC (.m4a) while preserving metadata and embedded artwork (if present).
# Output path mirrors the FLAC directory tree under $ALAC_DIR.
convert_to_alac() {
    local file="$1"
    local flac_root="${FLAC_DIR%/}"
    local relpath="${file#"$flac_root"/}"
    local outfile="$ALAC_DIR/${relpath%.flac}.m4a"

    # Skip if output already exists and is newer than input
    if [[ -f "$outfile" && "$outfile" -nt "$file" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$outfile")"
    # -map 0:a      : include audio streams
    # -map 0:v?     : include video streams if present (commonly embedded cover art)
    # -map_metadata : copy tags from source
    if ffmpeg -y -loglevel warning -i "$file" -ar 44100 -c:a alac -c:v copy -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1; then
        log "Converted to ALAC: $relpath"
    else
        log "ERROR: Failed to convert to ALAC: $relpath"
        return 1
    fi
}

# Convert one FLAC file to AAC (.m4a) while preserving metadata and embedded artwork (if present).
# Uses libfdk_aac if available in ffmpeg, otherwise falls back to the built-in aac encoder.
convert_to_aac() {
    local file="$1"
    local flac_root="${FLAC_DIR%/}"
    local relpath="${file#"$flac_root"/}"
    local outfile="$AAC_DIR/${relpath%.flac}.m4a"

    # Skip if output already exists and is newer than input
    if [[ -f "$outfile" && "$outfile" -nt "$file" ]]; then
        return 0
    fi

    mkdir -p "$(dirname "$outfile")"

    local ok=0
    if [[ "$AAC_ENCODER" == "libfdk_aac" ]]; then
        # libfdk_aac VBR mode.
        ffmpeg -y -loglevel warning -i "$file" -ar 44100 -ac 2 -c:a libfdk_aac -profile:a aac_low -vbr 4 -c:v copy -disposition:v attached_pic -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1 || ok=1
    else
        # Built-in encoder fallback: quality-based VBR (smaller is higher quality).
        ffmpeg -y -loglevel warning -i "$file" -ar 44100 -ac 2 -c:a aac -q:a 2 -c:v copy -disposition:v attached_pic -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1 || ok=1
    fi

    if [[ "$ok" -eq 0 ]]; then
        log "Converted to AAC: $relpath"
        return 0
    fi

    log "ERROR: Failed to convert to AAC: $relpath"
    return 1
}

# These conversions run via `xargs ... bash -c` in parallel.
# Export the functions and needed variables so each subprocess can call them.
export -f log convert_to_alac convert_to_aac
export LOG_FILE FLAC_DIR ALAC_DIR AAC_DIR AAC_ENCODER

# Step 3: Convert FLAC to ALAC
log "Converting FLAC files to ALAC format..."
if [[ -d "$ALAC_DIR" ]] || mkdir -p "$ALAC_DIR"; then
    if [[ ${#RECENT_FILES[@]} -gt 0 ]]; then
        # -print0/-0: safe for spaces/newlines in filenames.
        # -P: parallel jobs.
        # bash -c: run the exported function in a subprocess.
        printf '%s\0' "${RECENT_FILES[@]}" | \
            xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'convert_to_alac "$@"' _ {}
        log "FLAC to ALAC conversion completed."
    else
        log "Skipping ALAC conversion (no recent FLAC files)."
    fi
else
    log "ERROR: Cannot create ALAC output directory $ALAC_DIR"
fi

# Step 4: Convert FLAC to AAC
log "Converting FLAC files to AAC format..."
if [[ ! -d "$(dirname "$AAC_DIR")" ]]; then
    log "ERROR: Parent directory for AAC output does not exist: $(dirname "$AAC_DIR")"
    log "ERROR: Is the destination volume mounted?"
elif [[ -d "$AAC_DIR" ]] || mkdir -p "$AAC_DIR"; then
    if [[ ${#RECENT_FILES[@]} -gt 0 ]]; then
        # Same parallel pattern as ALAC.
        printf '%s\0' "${RECENT_FILES[@]}" | \
            xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'convert_to_aac "$@"' _ {}
        log "FLAC to AAC conversion completed."
    else
        log "Skipping AAC conversion (no recent FLAC files)."
    fi
else
    log "ERROR: Cannot create AAC output directory $AAC_DIR"
fi

# Step 5: Open newly converted ALAC directories in Music.app
log "Opening newly converted ALAC directories in Music.app..."
if [[ -d "$ALAC_DIR" ]]; then
    # Find directories modified within the recent timeframe (matching our conversion window)
    ALAC_RECENT_DIRS=()
    while IFS= read -r -d '' d; do
        ALAC_RECENT_DIRS+=("$d")
    done < <(find "$ALAC_DIR" -mindepth 1 -maxdepth 1 -type d -mmin "-$RECENT_MINS" -print0 2>/dev/null || true)

    if [[ ${#ALAC_RECENT_DIRS[@]} -gt 0 ]]; then
        for dir in "${ALAC_RECENT_DIRS[@]}"; do
            log "Opening in Music.app: $(basename "$dir")"
            open -a "Music.app" "$dir"
        done
        log "Opened ${#ALAC_RECENT_DIRS[@]} directory(ies) in Music.app."
    else
        log "No recently converted ALAC directories to open."
    fi
else
    log "WARNING: ALAC_DIR ($ALAC_DIR) does not exist. Skipping Music.app import."
fi

log "Music management tasks completed."