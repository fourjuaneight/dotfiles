#!/bin/bash

# This script reads music files from INPUT_DIR and sorts them into subdirectories based on their metadata:
# - Artist
# - Album
# The resulting structure will be: OUTPUT_DIR/Artist/Album/Track

set -euo pipefail

# Enable extended glob patterns used for filename normalization.
shopt -s extglob

MUSIC_DIR="$HOME/StreamripDownloads"
INPUT_DIR="$MUSIC_DIR/INTAKE"
OUTPUT_DIR="$MUSIC_DIR/OUTPUT"
LOG_FILE="$HOME/.scripts/logs/music_sorter.log"

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

# Format directory and files names by normalizing punctuation and removing diacritics.
fmt_names() {
  local input

  # join all args with spaces (closest practical analog to passing a string).
  if [[ $# -gt 0 ]]; then
    input="$*"
  else
    input="$(cat)"
  fi

        input="$(strip_version_suffixes "$input")"

    perl -CSDA -MUnicode::Normalize -pe '
        use utf8;
        use feature qw(unicode_strings);

        s/^\s//;

        s/[[:blank:]]+/_/g;
        s/_-_/-/g;
        s/_\(/-\(/g;
        s/_\[/-\[/g;

        s/[–—]/-/g;
        s/…/.../g;
        s/&amp;/&/g;
        s/[‘’]+/'"'"'/g;
        s/[“”]+/"/g;

        $_ = Unicode::Normalize::NFD($_);
        s/[\x{0300}-\x{036f}]+//g;

        s/[\x{202a}-\x{202c}]+//g;
    ' <<<"$input"
}

# Remove common version suffixes from a track title-like string.
# Removes (Album Version), (Single Version), and (YYYY Version), case-insensitive.
strip_version_suffixes() {
    local input
    if [[ $# -gt 0 ]]; then
        input="$*"
    else
        input="$(cat)"
    fi

    perl -CSDA -pe 's/\s*\((?:album|single|\d{4})\s+version\)//ig' <<<"$input"
}

# Normalize FLAC TITLE by removing common version suffixes.
# Safe behavior:
# - If TITLE is absent, does nothing.
# - If cleaned TITLE becomes empty, removes TITLE.
# - If metaflac fails, logs a warning and continues.
normalize_flac_title_tag() {
    local file="$1"

    local title_line title title_clean
    title_line="$(metaflac --show-tag=TITLE "$file" 2>/dev/null | head -n 1 || true)"
    title=""
    if [[ "$title_line" == TITLE=* ]]; then
        title="${title_line#TITLE=}"
    fi

    title_clean="$(strip_version_suffixes "$title")"
    title_clean="$(trim "$title_clean")"

    if [[ "$title_clean" == "$title" ]]; then
        return 0
    fi

    if [[ -n "$title_clean" ]]; then
        if ! metaflac --remove-tag=TITLE "--set-tag=TITLE=$title_clean" "$file"; then
            log "WARN: metaflac TITLE normalization failed: $file"
        fi
    else
        if ! metaflac --remove-tag=TITLE "$file"; then
            log "WARN: metaflac TITLE normalization failed: $file"
        fi
    fi
}

# Trim leading and trailing whitespace from a string.
# Usage: trimmed="$(trim "$value")"
# Prints the trimmed string to stdout.
trim() {
    local s="$1"
    # Trim leading/trailing whitespace.
    s="${s#${s%%[![:space:]]*}}"
    s="${s%${s##*[![:space:]]}}"
    printf '%s' "$s"
}

# Create a directory (and parents) if it doesn't exist.
# Usage: safe_mkdir "/path/to/dir"
safe_mkdir() {
    mkdir -p "$1"
}

# Derive the desired output filename for a track.
# Input format (basename):
#   TRACK_NUMBER. ARTIST - TRACK_NAME.flac
# Example:
#   01. Laura Pausini - Volveré junto a ti.flac
# Output format:
#   TRACK_NAME.flac
track_output_basename() {
    local src="$1"
    local base name ext rest
    base="$(basename "$src")"
    ext="${base##*.}"
    name="${base%.*}"

    # 1) Remove leading track number like "01. ".
    # Uses extglob: +([0-9]) = one-or-more digits.
    rest="${name##+([0-9]). }"
    rest="$(trim "$rest")"

    # 2) Remove leading "ARTIST - " (everything up to the first " - ").
    if [[ "$rest" == *" - "* ]]; then
        rest="${rest#* - }"
    fi
    rest="$(trim "$rest")"

    # Final cleanup/normalization for the output filename.
    # Note: fmt_names intentionally strips diacritics and normalizes punctuation.
    rest="$(fmt_names "$rest")"

    if [[ -z "$rest" ]]; then
        printf '%s' "$base"
        return 0
    fi

    printf '%s.%s' "$rest" "$ext"
}

# Move a file into a directory, without overwriting an existing file.
# - If the destination filename already exists, appends " (dupN)" before the extension.
# Usage: move_with_collision_handling <src_file> <dest_dir> [dest_basename]
# Prints the final destination path to stdout.
move_with_collision_handling() {
    local src="$1"
    local dest_dir="$2"
    local base
    base="${3:-$(basename "$src")}"

    safe_mkdir "$dest_dir"

    local dest="$dest_dir/$base"
    if [[ ! -e "$dest" ]]; then
        mv -n "$src" "$dest"
        printf '%s' "$dest"
        return 0
    fi

    local name="${base%.*}"
    local ext="${base##*.}"
    local i=1
    while :; do
        local candidate="$dest_dir/${name} (dup${i}).${ext}"
        if [[ ! -e "$candidate" ]]; then
            mv -n "$src" "$candidate"
            printf '%s' "$candidate"
            return 0
        fi
        i=$((i + 1))
    done
}

# Remove unwanted FLAC metadata tags using metaflac.
# Safe behavior:
# - If metaflac is missing, logs a warning and does nothing.
# - If metaflac fails for a file, logs a warning and continues.
strip_unwanted_flac_tags() {
    local file="$1"

    if ! require_cmd metaflac; then
        log "WARN: metaflac not found; skipping tag cleanup"
        return 0
    fi
    if [[ ! -f "$file" ]]; then
        log "WARN: Not a file; skipping tag cleanup: $file"
        return 0
    fi
    if [[ "${file##*.}" != "flac" && "${file##*.}" != "FLAC" ]]; then
        return 0
    fi

    # If DISCTOTAL is "01" (single-disc release), remove DISCNUMBER and DISCTOTAL as well.
    # (Some rippers store these even when redundant.)
    local disc_total_line disc_total
    disc_total_line="$(metaflac --show-tag=DISCTOTAL "$file" 2>/dev/null | head -n 1 || true)"
    disc_total="${disc_total_line#DISCTOTAL=}"
    disc_total="$(trim "$disc_total")"

    normalize_flac_title_tag "$file"

    local metaflac_args=(
        --remove-tag=COMPOSER
        --remove-tag=DESCRIPTION
        --remove-tag=COPYRIGHT
        --remove-tag=ISRC
    )
    if [[ "$disc_total" == "01" || "$disc_total" == "1" ]]; then
        metaflac_args+=(--remove-tag=DISCNUMBER --remove-tag=DISCTOTAL)
    fi

    if ! metaflac "${metaflac_args[@]}" "$file"; then
        log "WARN: metaflac tag cleanup failed: $file"
    fi
}

# Input: full path to a release directory.
# Expected basename:
#   {ARTIST} - {ALBUM} ({YEAR}) [FLAC] [16B-44.1kHz]
# Output: prints two lines to stdout:
#   line 1 = artist
#   line 2 = album
# Returns: 0 on success, 1 if the name doesn't match the expected pattern.
parse_release_dir() {
    local release_dir="$1"
    local base
    base="$(basename "$release_dir")"

    if [[ "$base" != *" - "* ]]; then
        return 1
    fi

    local artist rest album
    artist="${base%% - *}"
    rest="${base#* - }"
    album="${rest%% (*}"

    artist="$(trim "$artist")"
    album="$(trim "$album")"

    # Final cleanup/normalization for directory names.
    artist="$(fmt_names "$artist")"
    album="$(fmt_names "$album")"

    if [[ -z "$artist" || -z "$album" ]]; then
        return 1
    fi

    printf '%s\n%s\n' "$artist" "$album"
}

# Resolve (and optionally merge into) an existing directory whose normalized name matches.
# - If a directory already exists at "$parent/$desired", it is used.
# - Otherwise, if any existing immediate child directory of "$parent" normalizes to "$desired",
#   that existing directory path is returned (effectively merging into it).
# - If none matches, returns "$parent/$desired".
resolve_dir_merge() {
    local parent="$1"
    local desired="$2"

    if [[ -z "$parent" || -z "$desired" ]]; then
        return 1
    fi

    local direct="$parent/$desired"
    if [[ -d "$direct" ]]; then
        printf '%s' "$direct"
        return 0
    fi
    if [[ -e "$direct" && ! -d "$direct" ]]; then
        log "ERROR: Path exists but is not a directory: $direct"
        return 1
    fi

    if [[ -d "$parent" ]]; then
        local child base normalized
        while IFS= read -r -d '' child; do
            base="$(basename "$child")"
            normalized="$(fmt_names "$base")"
            if [[ "$normalized" == "$desired" ]]; then
                printf '%s' "$child"
                return 0
            fi
        done < <(find "$parent" -mindepth 1 -maxdepth 1 -type d -print0)
    fi

    printf '%s' "$direct"
}

# Delete a processed INTAKE release folder.
# This is called after successfully moving at least one track.
#
# NOTE: This deletes the entire release folder (including non-FLAC artifacts like cover.jpg).
# Safety: Only deletes paths that are direct children of INPUT_DIR.
delete_processed_folder() {
    local release_dir="$1"
    local moved_count="${2:-}" 

    # Safety checks to avoid accidental deletion of arbitrary paths.
    if [[ -z "$release_dir" ]]; then
        log "ERROR: delete_processed_folder called with empty path"
        return 1
    fi
    if [[ "$release_dir" != "$INPUT_DIR"/* ]]; then
        log "ERROR: Refusing to delete non-INTAKE path: $release_dir"
        return 1
    fi
    if [[ "$release_dir" == "$INPUT_DIR" ]]; then
        log "ERROR: Refusing to delete INPUT_DIR itself: $release_dir"
        return 1
    fi

    rm -rf -- "$release_dir"
    if [[ -n "$moved_count" ]]; then
        log "Done: moved $moved_count file(s), deleted intake folder: $release_dir"
    else
        log "Done: deleted intake folder: $release_dir"
    fi
}

# Main entry point:
# - Scans INPUT_DIR for release folders
# - Parses ARTIST/ALBUM from each folder name
# - Moves all .flac tracks into OUTPUT_DIR/ARTIST/ALBUM/
# - Removes the intake release folder only if it becomes empty
main() {
    if [[ ! -d "$INPUT_DIR" ]]; then
        log "ERROR: INPUT_DIR does not exist: $INPUT_DIR"
        exit 1
    fi
    safe_mkdir "$OUTPUT_DIR"

    local any=0
    while IFS= read -r -d '' release_dir; do
        any=1
        local parsed artist album
        if ! parsed="$(parse_release_dir "$release_dir")"; then
            log "SKIP: Unrecognized intake folder name: $(basename "$release_dir")"
            continue
        fi
        artist="${parsed%%$'\n'*}"
        album="${parsed#*$'\n'}"

        local artist_dir
        artist_dir="$(resolve_dir_merge "$OUTPUT_DIR" "$artist")"
        local dest_dir
        dest_dir="$(resolve_dir_merge "$artist_dir" "$album")"
        log "Processing: $(basename "$release_dir") -> $(basename "$artist_dir") / $(basename "$dest_dir")"

        local moved=0
        while IFS= read -r -d '' track; do
            local out_base
            out_base="$(track_output_basename "$track")"
            local moved_path
            moved_path="$(move_with_collision_handling "$track" "$dest_dir" "$out_base")"
            strip_unwanted_flac_tags "$moved_path"
            moved=$((moved + 1))
        done < <(find "$release_dir" -type f -iname '*.flac' -print0)

        if [[ "$moved" -eq 0 ]]; then
            log "WARN: No audio files found in: $release_dir"
            continue
        fi

        delete_processed_folder "$release_dir" "$moved"
    done < <(find "$INPUT_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

    if [[ "$any" -eq 0 ]]; then
        log "No release folders found in: $INPUT_DIR"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
