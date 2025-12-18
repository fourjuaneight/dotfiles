#!/bin/bash

# This script copies music files to the following B2 folders:
# - FLAC files: /Volumes/Sergio/Music to /Music/FLAC
# - ALAC files: /Volumes/Sergio/iTunes to /Music/ALAC
# - AAC  files: /Volumes/Sandro/iPod to /Music/AAC
# Only new or modified files are uploaded.

set -euo pipefail

# This script is intentionally conservative:
# - It uploads via `rclone copy` (no remote deletions)
# - It skips missing sources (volume not mounted) but exits non-zero if any copy fails

MUSIC_DIR="/Volumes/Sergio"
FLAC_DIR="$MUSIC_DIR/Music"
ALAC_DIR="$MUSIC_DIR/iTunes"
AAC_DIR="/Volumes/Sandro/iPod"

REMOTE_MUSIC_DIR="b2:Imladris/Music"
REMOTE_FLAC_DIR="$REMOTE_MUSIC_DIR/FLAC"
REMOTE_ALAC_DIR="$REMOTE_MUSIC_DIR/ALAC"
REMOTE_AAC_DIR="$REMOTE_MUSIC_DIR/AAC"

LOG_FILE="$HOME/.scripts/logs/music_sync.log"

# Ensure log directory exists (tee will fail under set -e otherwise)
mkdir -p "$(dirname "$LOG_FILE")"

# Check whether a command exists in PATH.
require_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# Log to stdout and to the log file.
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

usage() {
    cat <<'EOF'
Usage: musicSync.sh [--dry-run]

Uploads music libraries to Backblaze B2 via rclone.
Only new/changed files are uploaded (no deletions on remote).

Options:
  --dry-run   Show what would be uploaded without uploading.
EOF
}

DRY_RUN=0
# Simple arg parsing (keep UX minimal; only supports --dry-run and help).
if [[ ${1:-} == "--dry-run" ]]; then
    DRY_RUN=1
elif [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
    usage
    exit 0
elif [[ $# -gt 0 ]]; then
    usage
    exit 2
fi

if ! require_cmd rclone; then
    log "ERROR: rclone not found in PATH."
    exit 1
fi

# rclone flags:
# - Use `copy` (not `sync`) so we never delete remote files.
# - `--update` ensures we don't overwrite newer remote files.
# - `--fast-list` improves listing performance for large remotes.
# - `--transfers`/`--checkers` tune concurrency for faster uploads.
# - `--log-level` keeps rclone output reasonably terse.
RCLONE_FLAGS=(
    --update
    --fast-list
    --transfers 8
    --checkers 16
    --log-level INFO
)
if [[ "$DRY_RUN" -eq 1 ]]; then
    RCLONE_FLAGS+=(--dry-run)
    log "DRY RUN enabled: no uploads will be performed."
fi

# Upload one library to one B2 prefix.
# Returns non-zero on failure.
sync_one() {
    local label="$1"
    local src="$2"
    local dst="$3"

    if [[ ! -d "$src" ]]; then
        log "ERROR: Source directory missing (is the volume mounted?): $src"
        return 1
    fi

    log "Syncing $label: $src -> $dst"
    # Pipe rclone output into the log so failures are actionable.
    if rclone copy "${RCLONE_FLAGS[@]}" "$src" "$dst" 2>&1 | tee -a "$LOG_FILE"; then
        log "Done: $label"
        return 0
    fi

    log "ERROR: rclone failed for $label"
    return 1
}

# Run all three uploads. Each may live on a different external volume.
# Keep going even if one fails, then fail the script at the end.
main() {
    local failed=0

    # These may live on different volumes; handle independently.
    sync_one "FLAC" "$FLAC_DIR" "$REMOTE_FLAC_DIR" || failed=1
    sync_one "ALAC" "$ALAC_DIR" "$REMOTE_ALAC_DIR" || failed=1
    sync_one "AAC"  "$AAC_DIR"  "$REMOTE_AAC_DIR"  || failed=1

    if [[ "$failed" -ne 0 ]]; then
        log "Completed with errors."
        exit 1
    fi

    log "All music sync tasks completed successfully."
}

main "$@"
