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

# Step 1: Check for latest files
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
        echo "Converted to ALAC: $relpath"
    else
        echo "ERROR: Failed to convert to ALAC: $relpath" >&2
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
        echo "Converted to AAC: $relpath"
        return 0
    fi

    echo "ERROR: Failed to convert to AAC: $relpath" >&2
    return 1
}

# These conversions run via `xargs ... bash -c` in parallel.
# Export the functions and needed variables so each subprocess can call them.
export -f convert_to_alac convert_to_aac
export FLAC_DIR ALAC_DIR AAC_DIR AAC_ENCODER

# Step 2: Convert FLAC to ALAC
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

# Step 3: Convert FLAC to AAC
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

log "Music management tasks completed."