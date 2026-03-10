#!/usr/bin/env zsh
set -euo pipefail

# Hazel docs: shell scripts receive one argument ($1), the full path.
# This script is intended for a Hazel "Run shell script" action.

fmt_names() {
  local input

  # Join all args with spaces (closest practical analog to passing a string).
  if [[ $# -gt 0 ]]; then
    input="$*"
  else
    input="$(cat)"
  fi

  /usr/bin/perl -CSDA -MUnicode::Normalize -pe '
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

src="${1:-}"

# In Hazel actions, non-zero exits can cause repeated retries.
# Treat non-applicable inputs as a successful no-op.
[[ -z "$src" ]] && exit 0
[[ ! -e "$src" ]] && exit 0

rename_one() {
  local path="$1"
  local local_dir local_base dst_base dst
  local lower_base

  [[ ! -e "$path" ]] && return 0

  # Only rename PDF files; allow directories so folder names are still normalized.
  if [[ -f "$path" ]]; then
    lower_base="${path:t:l}"
    [[ "$lower_base" != *.pdf ]] && return 0
  fi

  # Normalize only the basename; keep parent path unchanged.
  local_dir="${path:h}"
  local_base="${path:t}"
  dst_base="$(fmt_names "$local_base")"

  [[ -z "$dst_base" ]] && return 0
  [[ "$local_base" == "$dst_base" ]] && return 0

  dst="$local_dir/$dst_base"
  [[ -e "$dst" ]] && return 0

  /bin/mv -- "$path" "$dst"
  echo "Renamed: $path -> $dst"
}

if [[ -d "$src" ]]; then
  # Depth-first traversal safely renames nested items before their parents.
  while IFS= read -r -d '' item; do
    rename_one "$item"
  done < <(/usr/bin/find "$src" -depth -mindepth 1 -print0)

  rename_one "$src"
else
  rename_one "$src"
fi