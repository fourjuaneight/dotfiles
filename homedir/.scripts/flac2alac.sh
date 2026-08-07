#!/bin/bash

# Standalone FLAC -> ALAC converter.
# Recursively converts every .flac under SOURCE_DIR, mirroring the directory
# tree under OUTPUT_DIR. Preserves tags and embedded cover art.
#
# Usage: flac2alac.sh SOURCE_DIR [OUTPUT_DIR]
#   SOURCE_DIR  Directory to scan for .flac files (recursive).
#   OUTPUT_DIR  Destination root for .m4a files (default: /Volumes/Sandro/Music/ALAC).

set -euo pipefail

PARALLEL_JOBS=4

usage() {
    echo "Usage: $(basename "$0") SOURCE_DIR [OUTPUT_DIR]" >&2
    exit 1
}

[[ $# -ge 1 && $# -le 2 ]] || usage

FLAC_DIR="${1%/}"
ALAC_DIR="${2:-/Volumes/Sandro/Music/ALAC}"
ALAC_DIR="${ALAC_DIR%/}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

if [[ ! -d "$FLAC_DIR" ]]; then
    log "ERROR: Source directory $FLAC_DIR does not exist."
    exit 1
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
    log "ERROR: ffmpeg not found in PATH."
    exit 1
fi

if ! mkdir -p "$ALAC_DIR"; then
    log "ERROR: Cannot create output directory $ALAC_DIR"
    exit 1
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
    # Target is iPod Classic 6th gen: stock firmware tops out at 16-bit/48kHz,
    # so everything is normalized to 44.1kHz/16-bit ALAC.
    # -af soxr      : high-quality resampler (default swr overshoots on loud masters)
    # -af alimiter  : catches resample overshoot in float, prevents clipped samples (clicks)
    # -af dither    : triangular_hp dither for the 24->16 bit reduction
    # -map 0:a      : include audio streams
    # -map 0:v?     : include video streams if present (commonly embedded cover art)
    # -map_metadata : copy tags from source
    if ffmpeg -y -nostdin -loglevel warning -i "$file" \
        -af "aresample=resampler=soxr:precision=28:osr=44100:out_sample_fmt=fltp,alimiter=limit=0.998:level=false,aresample=dither_method=triangular_hp" \
        -sample_fmt s16p -c:a alac -c:v copy -map 0:a -map 0:v? -map_metadata 0 "$outfile" 2>&1; then
        log "Converted to ALAC: $relpath"
    else
        log "ERROR: Failed to convert to ALAC: $relpath"
        return 1
    fi
}

export -f log convert_to_alac
export FLAC_DIR ALAC_DIR

FLAC_COUNT=$(find "$FLAC_DIR" -type f -name '*.flac' | wc -l | tr -d ' ')
if [[ "$FLAC_COUNT" -eq 0 ]]; then
    log "No FLAC files found under $FLAC_DIR."
    exit 0
fi

log "Converting $FLAC_COUNT FLAC file(s) from $FLAC_DIR to $ALAC_DIR..."
# -print0/-0: safe for spaces/newlines in filenames.
# -P: parallel jobs.
# bash -c: run the exported function in a subprocess.
find "$FLAC_DIR" -type f -name '*.flac' -print0 | \
    xargs -0 -P "$PARALLEL_JOBS" -I {} bash -c 'convert_to_alac "$@"' _ {}
log "FLAC to ALAC conversion completed."
